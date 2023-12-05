terraform {
  backend "s3" {
    bucket = "s3-bucket"
    key    = "aws-vpc-2.tfstate"
    region = "us-east-1"
  }
}