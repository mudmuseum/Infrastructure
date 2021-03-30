data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "mudmuseum_com" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  security_groups             = var.security_group_ids

  root_block_device {
    volume_size = var.root_block_device_volume_size
    volume_type = var.root_block_device_volume_type
    encrypted = true
  }
}

resource "aws_eip" "public_ip_mudmuseum_com" {
  instance = aws_instance.mudmuseum_com.id
}
