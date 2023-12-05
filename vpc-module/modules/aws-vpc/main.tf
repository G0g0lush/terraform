resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
   
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-ig"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.availability_zone)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.availability_zone)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_subnet_rta" {
  count = length(aws_subnet.public_subnets)
  
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_subnet_rt.id
}