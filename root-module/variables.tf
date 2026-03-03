variable "datadog_api_key" {
  description = "Datadog API key. Pass via TF_VAR_datadog_api_key or -var (e.g. from GitHub Actions secrets)."
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application key. Pass via TF_VAR_datadog_app_key or -var (e.g. from GitHub Actions secrets)."
  type        = string
  sensitive   = true
}

variable "product_name" {
  description = "Nome do projeto"
  type        = string
  default     = "POC-TEST"
}