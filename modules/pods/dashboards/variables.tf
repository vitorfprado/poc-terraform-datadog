variable "product_name" {
  description = "Nome do projeto (usado para compor o título padrão)"
  type        = string
}

variable "title" {
  description = "Título do dashboard (se não informado, usa o nome do produto)"
  type        = string  
}

variable "cluster_name" {
  description = "Valor default para a template variable 'cluster' do dashboard"
  type        = string
}

variable "namespace" {
  description = "Valor default para a template variable 'namespace' do dashboard"
  type        = string  
}

variable "deployment" {
  description = "Valor default para a template variable 'deployment' do dashboard"
  type        = string  
}
