terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.88.0"
    }
  }
}

resource "datadog_monitor" "monitor_erros_5xx" {
  name = "${var.product_name} - APM - Erro 5xx no serviço presenteia-api"
  type = "query alert"
  query = <<EOT
sum(last_5m):sum:trace.opentelemetry.instrumentation.fastapi.server.errors{http.status_code:5* , service:presenteia-api , span.kind:server , env:production} by {resource_name,http.status_code}.as_rate() > 5
EOT
  message = <<EOT
 ****Descricao**: Acionar o time de Produção CRM para validação dos erros e acionamentos dos times necessários 

Produto: ${var.product_name}

@googlechat-AlertasPresenteIA

EOT
  tags = ["service:poc"]
  priority = 2
  draft_status = "published"
  include_tags = false
  new_group_delay = 0
  notification_preset_name = "hide_query"
  on_missing_data = "default"
  require_full_window = false
  monitor_thresholds {
    critical = 5
    warning = 2
  }
}