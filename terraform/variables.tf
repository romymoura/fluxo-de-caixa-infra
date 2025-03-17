# Variáveis gerais
variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# Variáveis para o RDS (PostgreSQL)
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

# Variáveis para o SQS (Fila de Fluxo de Caixa e DLQ)
variable "queue_name" {
  description = "Nome da fila SQS para o fluxo de caixa"
  type        = string
  default     = "fluxo_caixa_queue"
}

variable "dlq_name" {
  description = "Nome da Dead Letter Queue (DLQ) para o fluxo de caixa"
  type        = string
  default     = "fluxo_caixa_dlq"
}

# Variáveis para o S3 (Armazenamento de sucesso do Worker)
variable "bucket_name" {
  description = "Nome do bucket S3 para armazenar os resultados consolidados"
  type        = string
  default     = "consolidado-fluxo-caixa"
}

# Variáveis para o ECS (API de Lançamento e Worker de Consolidação)
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

# Variáveis para o API Gateway
variable "api_name" {
  description = "Nome do API Gateway"
  type        = string
  default     = "fluxo-caixa-api"
}

variable "identity_server_url" {
  description = "URL do Identity Server para validação de tokens JWT"
  type        = string
}

variable "ecs_service_url" {
  description = "URL do serviço ECS (API de Lançamento)"
  type        = string
}

variable "stage_name" {
  description = "Nome do estágio do API Gateway (ex: dev, staging, prod)"
  type        = string
  default     = "dev"
}



# Variáveis para Observabilidade (Prometheus + Grafana)
variable "prometheus_namespace" {
  description = "Namespace para o Prometheus"
  type        = string
  default     = "prometheus"
}

variable "grafana_namespace" {
  description = "Namespace para o Grafana"
  type        = string
  default     = "grafana"
}

# Variáveis para as imagens dos contêineres
variable "api_image" {
  description = "Imagem Docker para a API de Lançamento"
  type        = string
  default     = "sua-imagem-api:latest"
}

variable "worker_image" {
  description = "Imagem Docker para o Worker de Consolidação"
  type        = string
  default     = "sua-imagem-worker:latest"
}

# Variáveis para configurações de rede
variable "vpc_id" {
  description = "ID da VPC onde os recursos serão criados"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets onde os recursos serão implantados"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs dos security groups para os recursos"
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}


variable "worker_role_arn" {
  description = "ARN da IAM Role associada ao Worker de Consolidação"
  type        = string
}


variable "sqs_queue_url" {
  description = "URL da fila SQS"
  type        = string
}

variable "rds_endpoint" {
  description = "Endpoint do RDS"
  type        = string
}
