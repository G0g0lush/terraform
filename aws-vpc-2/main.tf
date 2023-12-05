resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "internship-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = element(var.availability_zone, 0)
  map_public_ip_on_launch = true
  tags = {
    Type = "public"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = element(var.availability_zone, 1)
  tags = {
    Type = "private"
  }
}

resource "aws_internet_gateway" "i-gw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = element(var.from_internet, 0)
    gateway_id = aws_internet_gateway.i-gw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_rta" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_eip" "eip" {
  instance = aws_instance.ec2-instance.id
}

resource "aws_instance" "ec2-instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.ec2_key.key_name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = formatlist(aws_security_group.internship-tf-sg.id)
}