{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# RDS Dashboard: ${dashboard_name}\n**Instance:** ${db_instance_identifier}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "CPU Utilization",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Freeable Memory",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Free Storage Space",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Database Connections",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
        "title": "Read IOPS",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
        "title": "Write IOPS",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Read Latency",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
        "title": "Write Latency",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
        "title": "Network Throughput",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "NetworkReceiveThroughput", "DBInstanceIdentifier", "${db_instance_identifier}", { "label": "Receive" }],
          ["AWS/RDS", "NetworkTransmitThroughput", "DBInstanceIdentifier", "${db_instance_identifier}", { "label": "Transmit" }]
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
        "title": "Read Throughput",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "ReadThroughput", "DBInstanceIdentifier", "${db_instance_identifier}"]
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
      "y": 19,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Write Throughput",
        "region": "${region}",
        "metrics": [
          ["AWS/RDS", "WriteThroughput", "DBInstanceIdentifier", "${db_instance_identifier}"]
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Average"
      }
    }
  ]
}
