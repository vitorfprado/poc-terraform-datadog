terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.88.0"
    }
  }
}

resource "datadog_monitor" "monitor_latencia_p95" {
  name = "${var.product_name} - Alta latência para o serviço {{service.name}}"
  type = "query alert"
  query =  <<EOT
percentile(last_5m):p95:trace.opentelemetry.instrumentation.fastapi.server{env:production , service:presenteia-api} by {resource_name} - calendar_shift(p95:trace.opentelemetry.instrumentation.fastapi.server{env:production , service:presenteia-api} by {resource_name}, '-1w', 'America/Sao_Paulo') >= 5
EOT
 message = <<EOT
identificado um aumento de tempo de resposta no serviço {{resource_name.name}}  acima de {{threshold}}

FOI CRIADO UM MONITOR PARA CADA RESOURCE NAME DESSE ALERTA, FAVOR VERIFICAR NO ALERTA ESPECIFICO DO RESOURCE NAME

EOT
  tags = ["team:teste", "service:poc"]
  priority = 2
  draft_status = "published"
  evaluation_delay = 300
  group_retention_duration = "1h"
  new_group_delay = 60
  on_missing_data = "resolve"
  monitor_thresholds {
    critical = 5
    warning = 2
  }
}