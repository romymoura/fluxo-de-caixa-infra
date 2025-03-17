variable "api_name" {
  description = "Nome do api gateway"
  type        = string
  default     =  ""
}

variable "token_validator" {
  description = "ARN da Lambda autorizadora que valida o token"
  type        = string
}

variable "stage_name" {
  description = "Nome do estágio do API Gateway"
  type        = string
}

variable "ecs_service_url" {
  description = "URL do serviço ECS que o API Gateway irá invocar"
  type        = string
}

variable "lambda_arn" {
  description = "ARN da Lambda autorizadora"
  type        = string
}

variable "identity_server_url" {
  description = "URL do Identity Server para validação de tokens"
  type        = string
}

variable "authorizer_lambda_arn" {
  description = "O ARN da função Lambda que será usada como autorizador"
  type        = string
}

variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}