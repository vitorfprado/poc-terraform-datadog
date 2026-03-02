module "datadog_monitor_erros_5xx" {
  source       = "../modules/monitors/erros_5xx"
  product_name = var.product_name
  service_name = "meu-service-prod"
  operation_name = "minha-operacao"
  environment = "production"
}

module "datadog_dashboard_requests" {
  source         = "../modules/dashboard/requests"
  product_name   = var.product_name
  title          = "Dashboard de Requests - ${var.product_name}"
  service        = "meu-service-prod"
  resource_name  = "/minha/rota/*"
  operation_name = "*"
  http_url       = "*"
}

module "datadog_dashboard_pods" {
  source       = "../modules/dashboard/pods"
  product_name = var.product_name
  title        = "Dashboard de Pods - ${var.product_name}"
  cluster_name  = "meu-cluster-prod"
  namespace     = "meu-namespace-prod"
  deployment    = "meu-deployment-prod"
}

module "datadog_dashboard_rds_mysql" {
  source       = "../modules/dashboard/rds-mysql"
  product_name = var.product_name
  title        = "Dashboard de RDS MySQL - ${var.product_name}"
  account      = "*"
  region       = "*"
  dbinstance   = "meu-db-instance-prod"
  dbcluster    = "meu-db-cluster-prod"
}