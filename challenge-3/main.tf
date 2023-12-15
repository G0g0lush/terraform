resource "aws_key_pair" "citadel-key" {
  key_name = "citadel"
  public_key = file("/root/terraform-challenges/project-citadel/.ssh/ec2-connect-key.pub")
}
resource "aws_instance" "ec2" {
  ami = var.ami
  instance_type = var.instance_type
  user_data = file("install-nginx.sh")
  key_name = aws_key_pair.citadel-key.key_name
}
resource "aws_eip" "eip-ec2" {
  vpc = true
  instance = aws_instance.ec2.id
}
