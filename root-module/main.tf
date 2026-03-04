module "datadog_dashboard_requests" {
  source         = "../modules/requests"
  product_name   = var.product_name
  title          = "Dashboard de Requests - ${var.product_name}"
  service        = "meu-service-prod"
  resource_name  = "/minha/rota/*"
  operation_name = "*"
  http_url       = "*"
}

module "datadog_dashboard_pods" {
  source       = "../modules/eks/dashboards"
  product_name = var.product_name
  title        = "Dashboard de Pods - ${var.product_name}"
  cluster_name  = "meu-cluster-prod"
  namespace     = "meu-namespace-prod"
  deployment    = "meu-deployment-prod"
}

module "datadog_monitors" {
  source       = "../modules/eks/monitors"
  product_name = var.product_name
  title        = "Dashboard de Pods - ${var.product_name}"
  cluster_name  = "meu-cluster-prod"
  namespace     = "meu-namespace-prod"
  deployment    = "meu-deployment-prod"
  monitor_name =  "Monitor - Deploy com Poucas Réplicas -"
  team          = "meu-time-prod"
}


module "datadog_dashboard_rds_mysql" {
  source       = "../modules/rds-mysql"
  product_name = var.product_name
  title        = "Dashboard de RDS MySQL - ${var.product_name}"
  account      = "*"
  region       = "*"
  dbinstance   = "meu-db-instance-prod"
  dbcluster    = "meu-db-cluster-prod"
}

