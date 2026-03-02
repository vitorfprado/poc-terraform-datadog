variable "product_name" {
  description = "Nome do projeto"
  type        = string
}

variable "service_name" {
  description = "Nome do serviço monitorado (usado para compor o título e a query)"
  type        = string  
}

variable "operation_name" {
  description = "Nome da operação monitorada (usado para compor a query)"
  type        = string  
}

variable "environment" {
  description = "Ambiente em que o serviço está rodando (usado para compor a query)"
  type        = string
  default     = "production"
}