terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.88.0"
    }
  }
}

resource "datadog_monitor" "monitor_erros_5xx" {
  name = "${var.product_name} - APM - Erro 5xx no serviço ${var.service_name}"
  type = "query alert"
  query = <<EOT
sum(last_5m):sum:trace.${var.operation_name}{http.status_code:5* , service:${var.service_name} , span.kind:server , env:${var.environment}} by {resource_name,http.status_code}.as_rate() > 5
EOT
  message = <<EOT
 ****Descricao**: Acionar o time de Produção CRM para validação dos erros e acionamentos dos times necessários 

Produto: ${var.product_name}

@googlechat-AlertasPresenteIA

EOT
  tags = ["service:${var.service_name}"]
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