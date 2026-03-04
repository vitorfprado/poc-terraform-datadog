variable "product_name" {
  description = "Nome do projeto (usado para compor o título padrão)"
  type        = string
}

variable "title" {
  description = "Título do dashboard (se não informado, usa o nome do produto)"
  type        = string
  default     = ""
}

variable "service" {
  description = "Valor default para a template variable 'service' do dashboard"
  type        = string
  default     = "*"
}

variable "resource_name" {
  description = "Valor default para a template variable 'resource_name' do dashboard"
  type        = string
  default     = "*"
}

variable "operation_name" {
  description = "Valor default para a template variable 'operation_name' do dashboard"
  type        = string
  default     = "*"
}

variable "http_url" {
  description = "Valor default para a template variable 'http_url' do dashboard"
  type        = string
  default     = "*"
}