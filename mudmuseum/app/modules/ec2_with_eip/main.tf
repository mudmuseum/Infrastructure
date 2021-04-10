data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
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
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_size = var.root_block_device_volume_size
    volume_type = var.root_block_device_volume_type
    encrypted = true
  }
}

resource "aws_eip" "public_ip_mudmuseum_com" {
  instance = aws_instance.mudmuseum_com.id
}

resource "aws_route53_zone" "route53_zone_mudmuseum_com" {
  name          = var.route53_zone_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "route53_arecord_mud_mudmuseum_com" {
  zone_id         = aws_route53_zone.route53_zone_mudmuseum_com.zone_id
  allow_overwrite = true
  name            = var.route53_record_name
  type            = var.route53_record_type
  ttl             = var.route53_record_ttl
  records         = [aws_eip.public_ip_mudmuseum_com.public_ip]
}
