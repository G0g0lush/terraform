module "vpc-module" {
  source               = "./modules/aws-vpc"
  vpc_name             = "vpc-name"
  vpc_cidr_block       = "10.0.0.0/16"
  availability_zone  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.16.0/24", "10.0.32.0/24"]
  private_subnet_cidrs = ["10.0.64.0/24", "10.0.96.0/24"]
}