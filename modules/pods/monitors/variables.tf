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

variable "monitor_name" {
  description = "Nome do monitor de alertas (se não informado, usa um nome padrão)"
  type        = string 
}

variable "team" {
  description = "Nome do time responsável (usado para compor as tags dos monitores)"
  type        = string 
}
