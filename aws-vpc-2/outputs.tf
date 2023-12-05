output "ec2_public_ip" {
  value = aws_instance.ec2-instance.associate_public_ip_address
}

output "ec2_az" {
  value = aws_instance.ec2-instance.availability_zone
}