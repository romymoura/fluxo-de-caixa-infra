variable "db_name" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "fluxo_caixa_db"
}

variable "db_username" {
  description = "Usuário do banco de dados PostgreSQL"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha do banco de dados PostgreSQL"
  type        = string
  sensitive   = true
}