module "datadog_dashboard_poc" {
  source = "../modules/dashboard/poc"
  product_name = var.product_name  
}

module "datadog_monitor_p95" {
  source = "../modules/monitors/latencia_p95"
  product_name = var.product_name  
}

module "datadog_monitor_erros_5xx" {
  source = "../modules/monitors/erros_5xx"
  product_name = var.product_name  
}