resource "aws_key_pair" "ec2-instance" {
  key_name   = var.key_name
  public_key = var.public_key
}
