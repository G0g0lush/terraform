variable "vpc_name" {
  type    = string
}

variable "vpc_cidr_block" {
  type    = string
  description = "VPC CIDR block"
}

variable "availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR"
}