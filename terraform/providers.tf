# Variáveis gerais
variable "endpoint_local" {
  description                       = "Endpoint do LocalStack, Local onde será executado os comandos"
  type                              = string
}
variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}
variable "access_key" {
  description = "Acesso a chave da AWS"
  type        = string
}
variable "secret_key" {
  description = "Chave da AWS"
  type        = string
}
provider "aws" {
    access_key                      = "test"
    secret_key                      = "test"
    region                          = "us-east-1"

    s3_use_path_style               = true
    skip_credentials_validation     = true
    skip_metadata_api_check         = true
    skip_requesting_account_id      = true

    endpoints {
        apigateway                  = var.endpoint_local
        apigatewayv2                = var.endpoint_local
        cloudformation              = var.endpoint_local
        cloudwatch                  = var.endpoint_local
        dynamodb                    = var.endpoint_local
        ec2                         = var.endpoint_local
        #ecs                         = var.endpoint_local
        es                          = var.endpoint_local
        elasticache                 = var.endpoint_local
        firehose                    = var.endpoint_local
        iam                         = var.endpoint_local
        kinesis                     = var.endpoint_local
        lambda                      = var.endpoint_local
        rds                         = var.endpoint_local
        redshift                    = var.endpoint_local
        route53                     = var.endpoint_local
        s3                          = var.endpoint_local
        secretsmanager              = var.endpoint_local
        ses                         = var.endpoint_local
        sns                         = var.endpoint_local
        sqs                         = var.endpoint_local
        ssm                         = var.endpoint_local
        stepfunctions               = var.endpoint_local
        sts                         = var.endpoint_local
        elbv2                       = var.endpoint_local
    }
}