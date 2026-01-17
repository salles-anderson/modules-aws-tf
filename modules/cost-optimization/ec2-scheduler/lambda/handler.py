"""
Lambda function para stop/start de instâncias EC2.
Suporta operações agendadas para otimização de custos em ambientes dev/homolog.
"""

import boto3
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2_client = boto3.client('ec2')


def get_instances_by_tag(tag_key: str, tag_value: str) -> list:
    """Busca instâncias EC2 por tag."""
    instances = []

    paginator = ec2_client.get_paginator('describe_instances')
    filters = [
        {'Name': f'tag:{tag_key}', 'Values': [tag_value]},
        {'Name': 'instance-state-name', 'Values': ['running', 'stopped']}
    ]

    for page in paginator.paginate(Filters=filters):
        for reservation in page['Reservations']:
            for instance in reservation['Instances']:
                instances.append(instance['InstanceId'])

    return instances


def get_instance_name(instance_id: str) -> str:
    """Retorna o nome da instância (tag Name) ou o ID."""
    try:
        response = ec2_client.describe_instances(InstanceIds=[instance_id])
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                for tag in instance.get('Tags', []):
                    if tag['Key'] == 'Name':
                        return tag['Value']
    except Exception:
        pass
    return instance_id


def get_instance_state(instance_id: str) -> str:
    """Retorna o estado atual da instância."""
    try:
        response = ec2_client.describe_instances(InstanceIds=[instance_id])
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                return instance['State']['Name']
    except Exception:
        return 'unknown'


def stop_instance(instance_id: str) -> dict:
    """Para uma instância EC2."""
    instance_name = get_instance_name(instance_id)

    try:
        state = get_instance_state(instance_id)

        if state == 'running':
            ec2_client.stop_instances(InstanceIds=[instance_id])
            logger.info(f"Instância {instance_name} ({instance_id}) sendo parada.")
            return {
                'instance_id': instance_id,
                'instance_name': instance_name,
                'action': 'stopping',
                'previous_state': state
            }
        elif state == 'stopped':
            logger.info(f"Instância {instance_name} ({instance_id}) já está parada.")
            return {
                'instance_id': instance_id,
                'instance_name': instance_name,
                'action': 'skipped',
                'reason': 'Já está parada'
            }
        else:
            logger.info(f"Instância {instance_name} ({instance_id}) em estado {state}, não pode ser parada.")
            return {
                'instance_id': instance_id,
                'instance_name': instance_name,
                'action': 'skipped',
                'reason': f'Estado atual: {state}'
            }

    except ec2_client.exceptions.ClientError as e:
        if 'InvalidInstanceID' in str(e):
            logger.error(f"Instância {instance_id} não encontrada.")
            return {
                'instance_id': instance_id,
                'action': 'error',
                'reason': 'Instância não encontrada'
            }
        else:
            logger.error(f"Erro ao parar instância {instance_id}: {str(e)}")
            return {
                'instance_id': instance_id,
                'action': 'error',
                'reason': str(e)
            }
    except Exception as e:
        logger.error(f"Erro ao parar instância {instance_id}: {str(e)}")
        return {
            'instance_id': instance_id,
            'action': 'error',
            'reason': str(e)
        }


def start_instance(instance_id: str) -> dict:
    """Inicia uma instância EC2."""
    instance_name = get_instance_name(instance_id)

    try:
        state = get_instance_state(instance_id)

        if state == 'stopped':
            ec2_client.start_instances(InstanceIds=[instance_id])
            logger.info(f"Instância {instance_name} ({instance_id}) sendo iniciada.")
            return {
                'instance_id': instance_id,
                'instance_name': instance_name,
                'action': 'starting',
                'previous_state': state
            }
        elif state == 'running':
            logger.info(f"Instância {instance_name} ({instance_id}) já está rodando.")
            return {
                'instance_id': instance_id,
                'instance_name': instance_name,
                'action': 'skipped',
                'reason': 'Já está rodando'
            }
        else:
            logger.info(f"Instância {instance_name} ({instance_id}) em estado {state}, não pode ser iniciada.")
            return {
                'instance_id': instance_id,
                'instance_name': instance_name,
                'action': 'skipped',
                'reason': f'Estado atual: {state}'
            }

    except ec2_client.exceptions.ClientError as e:
        if 'InvalidInstanceID' in str(e):
            logger.error(f"Instância {instance_id} não encontrada.")
            return {
                'instance_id': instance_id,
                'action': 'error',
                'reason': 'Instância não encontrada'
            }
        else:
            logger.error(f"Erro ao iniciar instância {instance_id}: {str(e)}")
            return {
                'instance_id': instance_id,
                'action': 'error',
                'reason': str(e)
            }
    except Exception as e:
        logger.error(f"Erro ao iniciar instância {instance_id}: {str(e)}")
        return {
            'instance_id': instance_id,
            'action': 'error',
            'reason': str(e)
        }


def lambda_handler(event, context):
    """
    Handler principal da Lambda.

    Formato do evento:
    {
        "action": "stop" | "start",
        "instances": ["i-1234567890abcdef0"],  # Opcional: lista explícita de IDs
        "tag_key": "Environment",               # Opcional: buscar por tag
        "tag_value": "dev"                      # Opcional: valor da tag
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
            'body': json.dumps({
                'message': 'Nenhuma instância para processar',
                'results': []
            })
        }

    results = []

    for instance_id in instances:
        if action == 'stop':
            result = stop_instance(instance_id)
        elif action == 'start':
            result = start_instance(instance_id)
        else:
            result = {
                'instance_id': instance_id,
                'action': 'error',
                'reason': f'Ação inválida: {action}'
            }

        results.append(result)

    # Resumo
    stopped = len([r for r in results if r['action'] == 'stopping'])
    started = len([r for r in results if r['action'] == 'starting'])
    skipped = len([r for r in results if r['action'] == 'skipped'])
    errors = len([r for r in results if r['action'] == 'error'])

    response = {
        'statusCode': 200,
        'body': json.dumps({
            'action': action,
            'summary': {
                'total': len(results),
                'stopping': stopped,
                'starting': started,
                'skipped': skipped,
                'errors': errors
            },
            'results': results
        })
    }

    logger.info(f"Resposta: {json.dumps(response)}")
    return response
