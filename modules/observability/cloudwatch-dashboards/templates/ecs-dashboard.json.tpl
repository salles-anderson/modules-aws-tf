{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# ECS Dashboard: ${dashboard_name}\n**Cluster:** ${cluster_name}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "CPU Utilization",
        "region": "${region}",
        "metrics": [
%{ for idx, service in service_names ~}
          ["AWS/ECS", "CPUUtilization", "ClusterName", "${cluster_name}", "ServiceName", "${service}", { "label": "${service}" }]%{ if idx < length(service_names) - 1 },%{ endif }
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
      "y": 1,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Memory Utilization",
        "region": "${region}",
        "metrics": [
%{ for idx, service in service_names ~}
          ["AWS/ECS", "MemoryUtilization", "ClusterName", "${cluster_name}", "ServiceName", "${service}", { "label": "${service}" }]%{ if idx < length(service_names) - 1 },%{ endif }
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
      "x": 0,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Running Task Count",
        "region": "${region}",
        "metrics": [
%{ for idx, service in service_names ~}
          ["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", "${cluster_name}", "ServiceName", "${service}", { "label": "${service}" }]%{ if idx < length(service_names) - 1 },%{ endif }
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
      "x": 8,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Desired Task Count",
        "region": "${region}",
        "metrics": [
%{ for idx, service in service_names ~}
          ["ECS/ContainerInsights", "DesiredTaskCount", "ClusterName", "${cluster_name}", "ServiceName", "${service}", { "label": "${service}" }]%{ if idx < length(service_names) - 1 },%{ endif }
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
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Pending Task Count",
        "region": "${region}",
        "metrics": [
%{ for idx, service in service_names ~}
          ["ECS/ContainerInsights", "PendingTaskCount", "ClusterName", "${cluster_name}", "ServiceName", "${service}", { "label": "${service}" }]%{ if idx < length(service_names) - 1 },%{ endif }
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
      "x": 0,
      "y": 13,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Network RX Bytes",
        "region": "${region}",
        "metrics": [
%{ for idx, service in service_names ~}
          ["ECS/ContainerInsights", "NetworkRxBytes", "ClusterName", "${cluster_name}", "ServiceName", "${service}", { "label": "${service}" }]%{ if idx < length(service_names) - 1 },%{ endif }
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
      "x": 12,
      "y": 13,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Network TX Bytes",
        "region": "${region}",
        "metrics": [
%{ for idx, service in service_names ~}
          ["ECS/ContainerInsights", "NetworkTxBytes", "ClusterName", "${cluster_name}", "ServiceName", "${service}", { "label": "${service}" }]%{ if idx < length(service_names) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average"
      }
    }
  ]
}
