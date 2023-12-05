resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  for_each = var.public_subnet_loop

  vpc_id = aws_vpc.main-vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnet" {
  for_each = var.private_subnet_loop

  vpc_id = aws_vpc.main-vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_eip" "eip-nat" {
  domain = "vpc"
}

resource "aws_internet_gateway" "i-gw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "main"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id = values(aws_subnet.public-subnet)[0].id

  tags = {
    Name = "nat-gw"
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
  for_each = aws_subnet.public-subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table" "nat-gw-route" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = element(var.from_internet, 0)
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "NAT gateway"
  }
}

resource "aws_route_table_association" "private_subnet_rta" { 
  for_each = aws_subnet.private-subnet

  subnet_id = each.value.id
  route_table_id = aws_route_table.nat-gw-route.id
}


resource "aws_instance" "bastion-instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.ec2-key.key_name
  subnet_id              = values(aws_subnet.public-subnet)[0].id
  vpc_security_group_ids = formatlist(aws_security_group.bastion-instance-sg.id)
}

resource "aws_lb" "asg-lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.load-balancer-sg.id ]
  subnets            = values(aws_subnet.public-subnet)[*].id
}

resource "aws_lb_target_group" "asg-tg" {
  name     = var.lb_target_group
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main-vpc.id
}

resource "aws_lb_listener" "load-balancer-listener" {
  load_balancer_arn = aws_lb.asg-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg-tg.arn
  }
}

resource "aws_lb_listener_rule" "load-balancer-rule" {
  listener_arn = aws_lb_listener.load-balancer-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg-tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_launch_template" "asg" {
  name                   = var.asg_template
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.ec2-key.key_name
  vpc_security_group_ids = formatlist(aws_security_group.asg-sg.id)
  user_data = <<-EOF
      #!/bin/bash
      sudo yum update -y
      sudo yum install -y httpd
      sudo systemctl enable --now httpd
      echo `Greetings!` > /var/www/html/index.html
      sudo systemctl restart httpd

      EOF
}

resource "aws_autoscaling_group" "asg" {
  name = var.asg_name
  max_size = 3
  min_size = 1 
  desired_capacity = 3
  vpc_zone_identifier = values(aws_subnet.private-subnet)[*].id
  target_group_arns = [ aws_lb_target_group.asg-tg.arn ]

  launch_template {
    id = aws_launch_template.asg.id
  }
}

resource "aws_autoscaling_attachment" "asg-lb-attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn = aws_lb_target_group.asg-tg.arn
}