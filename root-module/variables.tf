variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string  
}

variable "datadog_app_key" {
  description = "Datadog Application key"
  type        = string  
}

variable "product_name" {
  description = "Nome do projeto"
  type        = string
  default = "poc"
}