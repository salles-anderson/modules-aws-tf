{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# Lambda Dashboard: ${dashboard_name}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Invocations",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in function_names ~}
          ["AWS/Lambda", "Invocations", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(function_names) - 1 },%{ endif }
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
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Errors",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in function_names ~}
          ["AWS/Lambda", "Errors", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(function_names) - 1 },%{ endif }
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
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "title": "Throttles",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in function_names ~}
          ["AWS/Lambda", "Throttles", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(function_names) - 1 },%{ endif }
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
      "x": 0,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Duration (Average)",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in function_names ~}
          ["AWS/Lambda", "Duration", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(function_names) - 1 },%{ endif }
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
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Duration (p99)",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in function_names ~}
          ["AWS/Lambda", "Duration", "FunctionName", "${fn}", { "label": "${fn}", "stat": "p99" }]%{ if idx < length(function_names) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "p99"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 13,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Concurrent Executions",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in function_names ~}
          ["AWS/Lambda", "ConcurrentExecutions", "FunctionName", "${fn}", { "label": "${fn}" }]%{ if idx < length(function_names) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Maximum"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 13,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Error Rate",
        "region": "${region}",
        "metrics": [
%{ for idx, fn in function_names ~}
          [{ "expression": "errors${idx}/invocations${idx}*100", "label": "${fn}", "id": "rate${idx}" }],
          ["AWS/Lambda", "Errors", "FunctionName", "${fn}", { "id": "errors${idx}", "visible": false }],
          ["AWS/Lambda", "Invocations", "FunctionName", "${fn}", { "id": "invocations${idx}", "visible": false }]%{ if idx < length(function_names) - 1 },%{ endif }
%{ endfor ~}
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 300,
        "stat": "Sum",
        "yAxis": {
          "left": {
            "min": 0,
            "label": "%",
            "showUnits": false
          }
        }
      }
    }
  ]
}
