"""
Lambda function para stop/start de instâncias RDS.
Suporta operações agendadas para otimização de custos em ambientes dev/homolog.
"""

import boto3
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

rds_client = boto3.client('rds')


def get_instances_by_tag(tag_key: str, tag_value: str) -> list:
    """Busca instâncias RDS por tag."""
    instances = []
    paginator = rds_client.get_paginator('describe_db_instances')

    for page in paginator.paginate():
        for instance in page['DBInstances']:
            instance_arn = instance['DBInstanceArn']
            tags_response = rds_client.list_tags_for_resource(ResourceName=instance_arn)

            for tag in tags_response.get('TagList', []):
                if tag['Key'] == tag_key and tag['Value'] == tag_value:
                    instances.append(instance['DBInstanceIdentifier'])
                    break

    return instances


def stop_instance(instance_id: str) -> dict:
    """Para uma instância RDS."""
    try:
        response = rds_client.describe_db_instances(DBInstanceIdentifier=instance_id)
        status = response['DBInstances'][0]['DBInstanceStatus']

        if status == 'available':
            rds_client.stop_db_instance(DBInstanceIdentifier=instance_id)
            logger.info(f"Instância {instance_id} sendo parada.")
            return {'instance': instance_id, 'action': 'stopping', 'previous_status': status}
        else:
            logger.info(f"Instância {instance_id} não está disponível para parar. Status: {status}")
            return {'instance': instance_id, 'action': 'skipped', 'reason': f'Status atual: {status}'}

    except rds_client.exceptions.DBInstanceNotFoundFault:
        logger.error(f"Instância {instance_id} não encontrada.")
        return {'instance': instance_id, 'action': 'error', 'reason': 'Instância não encontrada'}
    except Exception as e:
        logger.error(f"Erro ao parar instância {instance_id}: {str(e)}")
        return {'instance': instance_id, 'action': 'error', 'reason': str(e)}


def start_instance(instance_id: str) -> dict:
    """Inicia uma instância RDS."""
    try:
        response = rds_client.describe_db_instances(DBInstanceIdentifier=instance_id)
        status = response['DBInstances'][0]['DBInstanceStatus']

        if status == 'stopped':
            rds_client.start_db_instance(DBInstanceIdentifier=instance_id)
            logger.info(f"Instância {instance_id} sendo iniciada.")
            return {'instance': instance_id, 'action': 'starting', 'previous_status': status}
        else:
            logger.info(f"Instância {instance_id} não está parada. Status: {status}")
            return {'instance': instance_id, 'action': 'skipped', 'reason': f'Status atual: {status}'}

    except rds_client.exceptions.DBInstanceNotFoundFault:
        logger.error(f"Instância {instance_id} não encontrada.")
        return {'instance': instance_id, 'action': 'error', 'reason': 'Instância não encontrada'}
    except Exception as e:
        logger.error(f"Erro ao iniciar instância {instance_id}: {str(e)}")
        return {'instance': instance_id, 'action': 'error', 'reason': str(e)}


def lambda_handler(event, context):
    """
    Handler principal da Lambda.

    Formato do evento:
    {
        "action": "stop" | "start",
        "instances": ["instance-1", "instance-2"],  # Opcional: lista explícita
        "tag_key": "Environment",                    # Opcional: buscar por tag
        "tag_value": "dev"                           # Opcional: valor da tag
    }
    """
    logger.info(f"Evento recebido: {json.dumps(event)}")

    action = event.get('action', os.environ.get('DEFAULT_ACTION', 'stop'))
    instances = event.get('instances', [])
    tag_key = event.get('tag_key', os.environ.get('TAG_KEY'))
    tag_value = event.get('tag_value', os.environ.get('TAG_VALUE'))

    # Se não houver lista de instâncias, buscar por tag
    if not instances and tag_key and tag_value:
        logger.info(f"Buscando instâncias com tag {tag_key}={tag_value}")
        instances = get_instances_by_tag(tag_key, tag_value)
        logger.info(f"Instâncias encontradas: {instances}")

    if not instances:
        logger.warning("Nenhuma instância especificada ou encontrada por tag.")
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Nenhuma instância para processar', 'results': []})
        }

    results = []

    for instance_id in instances:
        if action == 'stop':
            result = stop_instance(instance_id)
        elif action == 'start':
            result = start_instance(instance_id)
        else:
            result = {'instance': instance_id, 'action': 'error', 'reason': f'Ação inválida: {action}'}

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
