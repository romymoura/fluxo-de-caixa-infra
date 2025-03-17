variable "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
  default     = "fluxo-caixa-cluster"
}

variable "api_service_name" {
  description = "Nome do serviço ECS para a API de Lançamento"
  type        = string
  default     = "api-lancamento"
}

variable "worker_service_name" {
  description = "Nome do serviço ECS para o Worker de Consolidação"
  type        = string
  default     = "worker-consolidacao"
}

variable "sqs_queue_url" {
  description = "URL da fila SQS"
  type        = string
}

variable "rds_endpoint" {
  description = "Endpoint do RDS"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde os recursos serão criados"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets onde os recursos serão implantados"
  type        = list(string)
}


# variable "execution_role_arn" {
#   description = "ARN do cluster do ECS onde a API e o WORK estão provisionados."
#   type        = string
# }
