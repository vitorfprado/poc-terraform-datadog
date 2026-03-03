variable "product_name" {
  description = "Nome do projeto (usado para compor o título padrão)"
  type        = string
}

variable "title" {
  description = "Título do dashboard (se não informado, usa o nome do produto)"
  type        = string  
}

variable "account" {
  description = "Valor default para a template variable 'account' do dashboard"
  type        = string
}

variable "region" {
  description = "Valor default para a template variable 'region' do dashboard"
  type        = string  
}

variable "dbinstance" {
  description = "Valor default para a template variable 'dbinstance' do dashboard"
  type        = string  
}

variable "dbcluster" {
  description = "Valor default para a template variable 'dbcluster' do dashboard"
  type        = string  
}
