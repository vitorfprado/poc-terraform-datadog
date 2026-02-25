terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.88.0"
    }
  }
}


locals {
  # Lê o JSON “modelo” exportado do Datadog
  dashboard_template = jsondecode(file("${path.module}/requests_dashboard.json"))

  # Define o título final do dashboard
  dashboard_title = length(trimspace(var.title)) > 0 ? var.title : "Dashboard - ${var.product_name} - Requests"

  # Aplica patch nas template variables do JSON (service, resource_name, operation_name, http_url)
  dashboard_template_variables_patched = [
    for tv in local.dashboard_template.template_variables :
    tv.name == "service" ? merge(tv, { default = var.service }) :
    tv.name == "resource_name" ? merge(tv, { default = var.resource_name }) :
    tv.name == "operation_name" ? merge(tv, { default = var.operation_name}) :
    tv.name == "http_url" ? merge(tv, { default = var.http_url }) :
    tv
  ]

  # JSON final que será enviado para o Datadog
  dashboard_final = merge(
    local.dashboard_template,
    {
      title              = local.dashboard_title
      template_variables = local.dashboard_template_variables_patched
    }
  )
}

resource "datadog_dashboard_json" "requests" {
  dashboard = jsonencode(local.dashboard_final)
}