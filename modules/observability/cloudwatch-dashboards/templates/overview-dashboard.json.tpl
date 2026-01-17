{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# ${project_name} - Overview Dashboard"
      }
    }
%{ if length(ecs_clusters) > 0 ~}
    ,
    {
      "type": "text",
      "x": 0,
      "y": 1,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "## ECS Services"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 2,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "ECS CPU Utilization",
        "region": "${region}",
        "metrics": [
%{ for idx, ecs in ecs_clusters ~}
          ["AWS/ECS", "CPUUtilization", "ClusterName", "${ecs.cluster_name}", "ServiceName", "${ecs.service_name}", { "label": "${ecs.service_name}" }]%{ if idx < length(ecs_clusters) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average",
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100,
            "label": "%",
            "showUnits": false
          }
        }
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 2,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "ECS Memory Utilization",
        "region": "${region}",
        "metrics": [
%{ for idx, ecs in ecs_clusters ~}
          ["AWS/ECS", "MemoryUtilization", "ClusterName", "${ecs.cluster_name}", "ServiceName", "${ecs.service_name}", { "label": "${ecs.service_name}" }]%{ if idx < length(ecs_clusters) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average",
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100,
            "label": "%",
            "showUnits": false
          }
        }
      }
    }
%{ endif ~}
%{ if length(rds_instances) > 0 ~}
    ,
    {
      "type": "text",
      "x": 0,
      "y": ${length(ecs_clusters) > 0 ? 8 : 1},
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "## RDS Instances"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": ${length(ecs_clusters) > 0 ? 9 : 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "RDS CPU Utilization",
        "region": "${region}",
        "metrics": [
%{ for idx, rds in rds_instances ~}
          ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${rds}", { "label": "${rds}" }]%{ if idx < length(rds_instances) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average",
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100,
            "label": "%",
            "showUnits": false
          }
        }
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": ${length(ecs_clusters) > 0 ? 9 : 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "RDS Connections",
        "region": "${region}",
        "metrics": [
%{ for idx, rds in rds_instances ~}
          ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${rds}", { "label": "${rds}" }]%{ if idx < length(rds_instances) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": ${length(ecs_clusters) > 0 ? 9 : 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "RDS Free Storage",
        "region": "${region}",
        "metrics": [
%{ for idx, rds in rds_instances ~}
          ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${rds}", { "label": "${rds}" }]%{ if idx < length(rds_instances) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average"
      }
    }
%{ endif ~}
%{ if length(lambda_functions) > 0 ~}
    ,
    {
      "type": "text",
      "x": 0,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + 1},
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "## Lambda Functions"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Lambda Invocations",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in lambda_functions ~}
          ["AWS/Lambda", "Invocations", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(lambda_functions) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Lambda Errors",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in lambda_functions ~}
          ["AWS/Lambda", "Errors", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(lambda_functions) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Lambda Duration",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in lambda_functions ~}
          ["AWS/Lambda", "Duration", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(lambda_functions) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average"
      }
    }
%{ endif ~}
%{ if length(alb_arns) > 0 ~}
    ,
    {
      "type": "text",
      "x": 0,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + (length(lambda_functions) > 0 ? 7 : 0) + 1},
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "## Application Load Balancers"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + (length(lambda_functions) > 0 ? 7 : 0) + 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "ALB Request Count",
        "region": "${region}",
        "metrics": [
%{ for idx, alb in alb_arns ~}
          ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${alb}", { "label": "${alb}" }]%{ if idx < length(alb_arns) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + (length(lambda_functions) > 0 ? 7 : 0) + 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "ALB 5XX Errors",
        "region": "${region}",
        "metrics": [
%{ for idx, alb in alb_arns ~}
          ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", "${alb}", { "label": "${alb}" }]%{ if idx < length(alb_arns) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": ${(length(ecs_clusters) > 0 ? 8 : 0) + (length(rds_instances) > 0 ? 7 : 0) + (length(lambda_functions) > 0 ? 7 : 0) + 2},
      "width": 8,
      "height": 6,
      "properties": {
        "title": "ALB Response Time",
        "region": "${region}",
        "metrics": [
%{ for idx, alb in alb_arns ~}
          ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${alb}", { "label": "${alb}" }]%{ if idx < length(alb_arns) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average"
      }
    }
%{ endif ~}
  ]
}
