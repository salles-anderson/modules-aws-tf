# Exemplo básico - Alarmes customizados com SNS
# Cria alarmes de métricas e tópico SNS para notificações

module "alarms" {
  source = "../../../modules/observability/cloudwatch-alarms"

  project_name = "minha-app"

  # Cria tópico SNS para notificações
  create_sns_topic = true

  # Assinaturas de email para o tópico
  sns_subscriptions = {
    team_email = {
      protocol = "email"
      endpoint = "team@example.com"
    }
    oncall = {
      protocol = "email"
      endpoint = "oncall@example.com"
    }
  }

  # Alarmes customizados
  metric_alarms = {
    high_cpu = {
      alarm_name          = "HighCPU-minha-app"
      alarm_description   = "CPU acima de 80% por 5 minutos"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      dimensions = {
        InstanceId = "i-1234567890abcdef0"
      }
    }
    low_disk = {
      alarm_name          = "LowDisk-minha-app"
      alarm_description   = "Espaço em disco abaixo de 10%"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 2
      metric_name         = "disk_used_percent"
      namespace           = "CWAgent"
      period              = 300
      statistic           = "Average"
      threshold           = 10
      dimensions = {
        InstanceId = "i-1234567890abcdef0"
        device     = "xvda1"
        fstype     = "ext4"
        path       = "/"
      }
    }
  }

  tags = {
    Environment = "production"
  }
}

output "sns_topic_arn" {
  value = module.alarms.sns_topic_arn
}

output "metric_alarm_arns" {
  value = module.alarms.metric_alarm_arns
}
