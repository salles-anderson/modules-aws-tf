# Exemplo básico - Dashboard customizado
# Cria dashboard com JSON personalizado

module "dashboards" {
  source = "../../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-app"
  aws_region   = "us-east-1"

  # Dashboard customizado com JSON
  dashboards = {
    custom = {
      body = jsonencode({
        widgets = [
          {
            type   = "metric"
            x      = 0
            y      = 0
            width  = 12
            height = 6
            properties = {
              metrics = [
                ["AWS/EC2", "CPUUtilization", "InstanceId", "i-1234567890abcdef0"]
              ]
              period = 300
              stat   = "Average"
              region = "us-east-1"
              title  = "CPU Utilization"
            }
          },
          {
            type   = "metric"
            x      = 12
            y      = 0
            width  = 12
            height = 6
            properties = {
              metrics = [
                ["AWS/EC2", "NetworkIn", "InstanceId", "i-1234567890abcdef0"],
                [".", "NetworkOut", ".", "."]
              ]
              period = 300
              stat   = "Average"
              region = "us-east-1"
              title  = "Network I/O"
            }
          }
        ]
      })
    }
  }

  tags = {
    Environment = "production"
  }
}

output "dashboard_arns" {
  value = module.dashboards.dashboard_arns
}
