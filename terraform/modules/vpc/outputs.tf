output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.fluxo_de_caixa_vpc.id
}

output "subnet_ids" {
  description = "IDs das subnets criadas"
  value       = aws_subnet.fluxo_de_caixa_subnets[*].id
}