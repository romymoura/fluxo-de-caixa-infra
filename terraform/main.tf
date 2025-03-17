provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
}

module "rds" {
  source = "./modules/rds"
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "sqs" {
  source = "./modules/sqs"
  queue_name = var.queue_name
  dlq_name = var.dlq_name
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  worker_role_arn = aws_iam_role.worker_role.arn
}

module "ecs" {
  source = "./modules/ecs"
  ecs_cluster_name      = var.ecs_cluster_name
  api_service_name      = var.api_service_name
  worker_service_name   = var.worker_service_name
  sqs_queue_url         = module.sqs.queue_url
  rds_endpoint          = module.rds.rds_endpoint
  s3_bucket_name        = module.s3.bucket_name
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.subnet_ids
  //execution_role_arn    = var.execution_role_arn
}
resource "aws_iam_role" "worker_role" {
  name = "worker-consolidacao-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy" "worker_s3_policy" {
  name = "worker-s3-policy"
  role = aws_iam_role.worker_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*"
        ]
      }
    ]
  })
}
data "aws_iam_role" "worker_s3_policy" {
  name = "worker-consolidacao-role"
}

module "lambda" {
  source               = "./modules/lambda"
  identity_server_url  = var.identity_server_url
}

module "api_gateway" {
  source = "./modules/api_gateway"
  api_name           = var.api_name
  lambda_arn       = module.lambda.authorizer_lambda_arn
  identity_server_url = var.identity_server_url
  ecs_service_url    = module.ecs.api_service_url
  stage_name         = var.stage_name
  token_validator  = module.lambda.authorizer_lambda_arn
  authorizer_lambda_arn = module.lambda.authorizer_lambda_arn
  aws_region = var.aws_region
}

module "observability" {
  source = "./modules/observability"
  prometheus_namespace = var.prometheus_namespace
  grafana_namespace = var.grafana_namespace
  ecs_task_execution_role_arn   = module.ecs.ecs_task_execution_role_arn
}