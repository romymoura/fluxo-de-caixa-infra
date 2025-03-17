variable "bucket_name" {
  description = "Nome do bucket S3 para armazenar os resultados consolidados"
  type        = string
  default     = "consolidado-fluxo-caixa"
}

variable "worker_role_arn" {
  description = "ARN da IAM Role associada ao Worker de Consolidação"
  type        = string
}