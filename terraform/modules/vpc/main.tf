resource "aws_vpc" "fluxo_de_caixa_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "fluxo_de_caixa-vpc"
  }
}

resource "aws_subnet" "fluxo_de_caixa_subnets" {
  count = 2
  vpc_id            = aws_vpc.fluxo_de_caixa_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fluxo_de_caixa_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "fluxo-de-caixa-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "fluxo_de_caixa_igw" {
  vpc_id = aws_vpc.fluxo_de_caixa_vpc.id

  tags = {
    Name = "fluxo-de-caixa-igw"
  }
}

resource "aws_route_table" "fluxo_de_caixa_public_rt" {
  vpc_id = aws_vpc.fluxo_de_caixa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fluxo_de_caixa_igw.id
  }

  tags = {
    Name = "fluxo-de-caixa-public-route-table"
  }
}

resource "aws_route_table_association" "fluxo_de_caixa_public_ass" {
  count = length(aws_subnet.fluxo_de_caixa_subnets)
  subnet_id      = aws_subnet.fluxo_de_caixa_subnets[count.index].id
  route_table_id = aws_route_table.fluxo_de_caixa_public_rt.id
}