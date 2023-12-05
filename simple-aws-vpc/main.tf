resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.vpc_name}-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name} IG"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}