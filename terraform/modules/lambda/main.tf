resource "aws_lambda_function" "authorizer" {
  function_name = "identity-server-authorizer"
  runtime       = "python3.9"
  handler       = "main.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda_authorizer.zip"  # Caminho correto para o ZIP

  environment {
    variables = {
      IDENTITY_SERVER_URL = var.identity_server_url
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

