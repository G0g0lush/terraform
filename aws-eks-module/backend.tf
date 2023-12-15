terraform {
  backend "s3" {
    bucket = "bucket-name"
    key    = "eks-module.tfstate"
    region = "us-east-1"
  }
}