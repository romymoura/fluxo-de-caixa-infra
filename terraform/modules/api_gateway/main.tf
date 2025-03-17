resource "aws_api_gateway_rest_api" "fluxo_de_caixa_api_gateway" {
  name        = "secured-api"
  description = "API Gateway com Lambda Authorizer"
}

# resource "aws_api_gateway_authorizer" "lambda_authorizer" {
#   name                   = "jwt-authorizer"
#   rest_api_id            = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
#   authorizer_uri         = var.authorizer_lambda_arn
#   type                   = "TOKEN"
# }

# resource "aws_api_gateway_authorizer" "lambda_authorizer" {
#   name                    = "LambdaAuthorizer"
#   rest_api_id             = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
#   type                    = "TOKEN"
#   authorizer_uri          = var.authorizer_lambda_arn  # Usando a variável
#   identity_source         = "method.request.header.Authorization"
#   authorizer_result_ttl_in_seconds = 300
# }

# resource "aws_api_gateway_authorizer" "lambda_authorizer" {
#   name                   = "lambda-authorizer"
#   rest_api_id            = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
#   authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
#   authorizer_credentials = aws_iam_role.invocation_role.arn
#   type                   = "TOKEN"
#   identity_source        = "method.request.header.Authorization"
# }

resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                    = "LambdaAuthorizer"
  rest_api_id             = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
  authorizer_uri          = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.authorizer_lambda_arn}/invocations"
  type                    = "TOKEN"
  identity_source         = "method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 300
}


resource "aws_api_gateway_resource" "protected" {
  rest_api_id = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.root_resource_id
  path_part   = "protected"
}

resource "aws_api_gateway_method" "protected_method" {
  rest_api_id   = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
  resource_id   = aws_api_gateway_resource.protected.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
  resource_id = aws_api_gateway_resource.protected.id
  http_method = aws_api_gateway_method.protected_method.http_method
  integration_http_method = "POST"
  type = "HTTP_PROXY"
  uri  = var.identity_server_url  # Usando a variável aqui
}


resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
  stage_name  = "prod"  # Ajuste para o nome de estágio desejado
  description = "Deployment da API para o stage de produção"

  # Definindo como depende da criação do API Gateway para garantir que o deploy seja realizado após a criação
  depends_on = [
    aws_api_gateway_method.protected_method,  # Certifique-se de que o método da API esteja configurado corretamente
    aws_api_gateway_resource.protected   # Certifique-se de que o recurso da API esteja configurado
  ]
}


resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}




