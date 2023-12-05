resource "aws_security_group" "internship-tf-sg" {
  name   = var.security_group_name
  vpc_id = aws_vpc.internship-main.id

  dynamic "ingress" {
    for_each = var.ingress_sg

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.from_internet
    }
  }

  dynamic "egress" {
    for_each = var.egress_sg

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = var.from_internet
    }
  }
}
