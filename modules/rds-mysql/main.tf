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
  dashboard_template = jsondecode(file("${path.module}/rds_dashboard.json"))

  # Define o título final do dashboard
  dashboard_title = length(trimspace(var.title)) > 0 ? var.title : "Dashboard - ${var.product_name} - RDS"

  # Aplica patch nas template variables do JSON (service, resource_name, operation_name, http_url)
  dashboard_template_variables_patched = [
    for tv in local.dashboard_template.template_variables :
    tv.name == "account" ? merge(tv, { default = var.account }) :
    tv.name == "region" ? merge(tv, { default = var.region }) :
    tv.name == "dbinstance" ? merge(tv, { default = var.dbinstance }) : 
    tv.name == "dbcluster" ? merge(tv, { default = var.dbcluster }) :   
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
