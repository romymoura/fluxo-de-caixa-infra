variable "vpc_cidr_block" {
  description = "Bloco CIDR para o VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "ID da VPC onde os recursos serão criados"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets onde os recursos serão implantados"
  type        = list(string)
}