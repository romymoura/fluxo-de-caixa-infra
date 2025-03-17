output "api_name" {
  description = "Nome do api gateway"
  value       = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.name
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_rest_api.fluxo_de_caixa_api_gateway.execution_arn
}


