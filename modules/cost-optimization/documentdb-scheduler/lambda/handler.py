"""
Lambda function para stop/start de clusters DocumentDB.
Suporta operações agendadas para otimização de custos em ambientes dev/homolog.
"""

import boto3
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

docdb_client = boto3.client('docdb')


def get_clusters_by_tag(tag_key: str, tag_value: str) -> list:
    """Busca clusters DocumentDB por tag."""
    clusters = []
    paginator = docdb_client.get_paginator('describe_db_clusters')

    for page in paginator.paginate():
        for cluster in page['DBClusters']:
            # Filtrar apenas clusters DocumentDB (engine = docdb)
            if cluster.get('Engine') != 'docdb':
                continue

            cluster_arn = cluster['DBClusterArn']
            tags_response = docdb_client.list_tags_for_resource(ResourceName=cluster_arn)

            for tag in tags_response.get('TagList', []):
                if tag['Key'] == tag_key and tag['Value'] == tag_value:
                    clusters.append(cluster['DBClusterIdentifier'])
                    break

    return clusters


def stop_cluster(cluster_id: str) -> dict:
    """Para um cluster DocumentDB."""
    try:
        response = docdb_client.describe_db_clusters(DBClusterIdentifier=cluster_id)
        status = response['DBClusters'][0]['Status']

        if status == 'available':
            docdb_client.stop_db_cluster(DBClusterIdentifier=cluster_id)
            logger.info(f"Cluster {cluster_id} sendo parado.")
            return {'cluster': cluster_id, 'action': 'stopping', 'previous_status': status}
        else:
            logger.info(f"Cluster {cluster_id} não está disponível para parar. Status: {status}")
            return {'cluster': cluster_id, 'action': 'skipped', 'reason': f'Status atual: {status}'}

    except docdb_client.exceptions.DBClusterNotFoundFault:
        logger.error(f"Cluster {cluster_id} não encontrado.")
        return {'cluster': cluster_id, 'action': 'error', 'reason': 'Cluster não encontrado'}
    except Exception as e:
        logger.error(f"Erro ao parar cluster {cluster_id}: {str(e)}")
        return {'cluster': cluster_id, 'action': 'error', 'reason': str(e)}


def start_cluster(cluster_id: str) -> dict:
    """Inicia um cluster DocumentDB."""
    try:
        response = docdb_client.describe_db_clusters(DBClusterIdentifier=cluster_id)
        status = response['DBClusters'][0]['Status']

        if status == 'stopped':
            docdb_client.start_db_cluster(DBClusterIdentifier=cluster_id)
            logger.info(f"Cluster {cluster_id} sendo iniciado.")
            return {'cluster': cluster_id, 'action': 'starting', 'previous_status': status}
        else:
            logger.info(f"Cluster {cluster_id} não está parado. Status: {status}")
            return {'cluster': cluster_id, 'action': 'skipped', 'reason': f'Status atual: {status}'}

    except docdb_client.exceptions.DBClusterNotFoundFault:
        logger.error(f"Cluster {cluster_id} não encontrado.")
        return {'cluster': cluster_id, 'action': 'error', 'reason': 'Cluster não encontrado'}
    except Exception as e:
        logger.error(f"Erro ao iniciar cluster {cluster_id}: {str(e)}")
        return {'cluster': cluster_id, 'action': 'error', 'reason': str(e)}


def lambda_handler(event, context):
    """
    Handler principal da Lambda.

    Formato do evento:
    {
        "action": "stop" | "start",
        "clusters": ["cluster-1", "cluster-2"],  # Opcional: lista explícita
        "tag_key": "Environment",                 # Opcional: buscar por tag
        "tag_value": "dev"                        # Opcional: valor da tag
    }
    """
    logger.info(f"Evento recebido: {json.dumps(event)}")

    action = event.get('action', os.environ.get('DEFAULT_ACTION', 'stop'))
    clusters = event.get('clusters', [])
    tag_key = event.get('tag_key', os.environ.get('TAG_KEY'))
    tag_value = event.get('tag_value', os.environ.get('TAG_VALUE'))

    # Se não houver lista de clusters, buscar por tag
    if not clusters and tag_key and tag_value:
        logger.info(f"Buscando clusters com tag {tag_key}={tag_value}")
        clusters = get_clusters_by_tag(tag_key, tag_value)
        logger.info(f"Clusters encontrados: {clusters}")

    if not clusters:
        logger.warning("Nenhum cluster especificado ou encontrado por tag.")
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Nenhum cluster para processar', 'results': []})
        }

    results = []

    for cluster_id in clusters:
        if action == 'stop':
            result = stop_cluster(cluster_id)
        elif action == 'start':
            result = start_cluster(cluster_id)
        else:
            result = {'cluster': cluster_id, 'action': 'error', 'reason': f'Ação inválida: {action}'}

        results.append(result)

    response = {
        'statusCode': 200,
        'body': json.dumps({
            'action': action,
            'processed': len(results),
            'results': results
        })
    }

    logger.info(f"Resposta: {json.dumps(response)}")
    return response
