variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the VPC"
}

variable "availability_zone" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  description = "List of availability zones"
}

variable "instance_type" {
  type        = string
  description = "Instance type of the ec2 instance"
}

variable "bastion_security_group_name" {
  type        = string
  description = "Name of the bastion instance Security Group"
}

variable "ingress_bastion" {
  type        = list(string)
  description = "Ingress ports for bastion Security Group"
  default     = ["22"]
}

variable "egress_bastion" {
  type        = list(string)
  description = "Egress ports for bastion Security Group"
  default     = ["0"]
}

variable "asg_security_group_name" {
  type        = string
  description = "Name of ASG Security Group"
}

variable "ingress_asg" {
  type        = list(string)
  description = "Ingress ports for ASG Security Group"
  default     = ["22", "80"]
}

variable "egress_asg" {
  type        = list(string)
  description = "Egress ports for ASG Security Group"
  default     = ["0"]
}

variable "from_internet" {
  type        = list(string)
  description = "CIDR block that allows you to connect from everywhere"
  default     = ["0.0.0.0/0"]
}

variable "asg_template" {
  type        = string
  description = "Name of ASG launch template"
}

variable "asg_name" {
  type        = string
  description = "Name of ASG"
}

variable "lb_name" {
  type        = string
  description = "Name of Load Balancer"
}

variable "lb_target_group" {
  type        = string
  description = "Name of Load Balancer Target Group"
}

variable "private_subnet_loop" {
  type = map
  default = {
    private-subnet-1 = {
      cidr_block = "10.0.32.0/24"
      availability_zone = "us-east-1a"
    }
    private-subnet-2 = {
      cidr_block = "10.0.64.0/24"
      availability_zone = "us-east-1b"
    }
    private-subnet-3 = {
      cidr_block = "10.0.96.0/24"
      availability_zone = "us-east-1c"
    }
  }
}

variable "public_subnet_loop" {
  type = map
  default = {
    public-subnet-1 = {
      cidr_block = "10.0.16.0/24"
      availability_zone = "us-east-1a"
    }
    public-subnet-2 = {
      cidr_block = "10.0.112.0/24"
      availability_zone = "us-east-1b"
    }
  }
}

variable "lb_security_group_name" {
  type        = string
  description = "Name of the bastion instance Security Group"
}

variable "ingress_lb" {
  type        = list(string)
  description = "Ingress ports for bastion Security Group"
  default     = ["80"]
}

variable "egress_lb" {
  type        = list(string)
  description = "Egress ports for bastion Security Group"
  default     = ["0"]
}