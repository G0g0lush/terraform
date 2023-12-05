terraform {
  backend "s3" {
    bucket = "s3-bucket"
    key    = "vpc-alb.tfstate"
    region = "us-east-1"
  }
}