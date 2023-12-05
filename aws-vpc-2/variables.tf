variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the VPC"
}

variable "availability_zone" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of availability zones"
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "CIDR block of the public subnet"
}

variable "private_subnet_cidr_block" {
  type        = string
  description = "CIDR block of the private subnet"
}

variable "instance_type" {
  type        = string
  description = "Instance type of the ec2 instance"
}

variable "security_group_name" {
  type        = string
  description = "Name of the security group"
}

variable "ingress_sg" {
  type        = list(string)
  description = "Ingress ports for Security Group"
  default     = ["22", "80"]
}

variable "egress_sg" {
  type        = list(string)
  description = "Egress ports for Security Group"
  default     = ["0"]
}

variable "from_internet" {
  type        = list(string)
  description = "CIDR block that allows you to connect from everywhere"
  default     = ["0.0.0.0/0"]
}