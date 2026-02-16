terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.88.0"
    }
  }
}

resource "datadog_dashboard_json" "poc" {
  dashboard = file("${path.module}/poc_dashboard.json")
}



