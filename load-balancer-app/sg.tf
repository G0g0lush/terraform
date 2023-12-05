resource "aws_security_group" "bastion-instance-sg" {
  name   = var.bastion_security_group_name
  vpc_id = aws_vpc.internship-main.id

  dynamic "ingress" {
    for_each = var.ingress_bastion

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.from_internet
    }
  }

  dynamic "egress" {
    for_each = var.egress_bastion

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = var.from_internet
    }
  }
}

resource "aws_security_group" "asg-sg" {
  name   = var.asg_security_group_name
  vpc_id = aws_vpc.internship-main.id

  dynamic "ingress" {
    for_each = var.ingress_asg

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      security_groups = [ aws_security_group.bastion-instance-sg.id ]
    }
  }

  dynamic "egress" {
    for_each = var.egress_asg

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = var.from_internet
    }
  }
}

resource "aws_security_group" "lb-sg" {
  name   = var.lb_security_group_name
  vpc_id = aws_vpc.internship-main.id

  dynamic "ingress" {
    for_each = var.ingress_lb

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.from_internet
    }
  }

  dynamic "egress" {
    for_each = var.egress_lb

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = var.from_internet
    }
  }
}