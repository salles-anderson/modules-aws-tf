{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# ALB Dashboard: ${dashboard_name}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Request Count",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${load_balancer_arn_suffix}"]
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
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Active Connection Count",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", "${load_balancer_arn_suffix}"]
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
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "New Connection Count",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "NewConnectionCount", "LoadBalancer", "${load_balancer_arn_suffix}"]
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "HTTP Status Codes (ELB)",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "HTTPCode_ELB_2XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "2XX" }],
          ["AWS/ApplicationELB", "HTTPCode_ELB_3XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "3XX" }],
          ["AWS/ApplicationELB", "HTTPCode_ELB_4XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "4XX" }],
          ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "5XX" }]
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "HTTP Status Codes (Target)",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "2XX" }],
          ["AWS/ApplicationELB", "HTTPCode_Target_3XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "3XX" }],
          ["AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "4XX" }],
          ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "5XX" }]
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 13,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Target Response Time",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "Average", "stat": "Average" }],
          ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${load_balancer_arn_suffix}", { "label": "p99", "stat": "p99" }]
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
      "y": 13,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Healthy Host Count",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", "${load_balancer_arn_suffix}", "TargetGroup", "${target_group_arn_suffix}"]
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
      "y": 13,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Unhealthy Host Count",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", "${load_balancer_arn_suffix}", "TargetGroup", "${target_group_arn_suffix}"]
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
      "y": 19,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Processed Bytes",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", "${load_balancer_arn_suffix}"]
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 19,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Rejected Connection Count",
        "region": "${region}",
        "metrics": [
          ["AWS/ApplicationELB", "RejectedConnectionCount", "LoadBalancer", "${load_balancer_arn_suffix}"]
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum"
      }
    }
  ]
}
