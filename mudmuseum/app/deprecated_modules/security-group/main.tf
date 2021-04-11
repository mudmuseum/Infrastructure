resource "aws_security_group" "security_group" {

  name   = var.security_group_name
  vpc_id = var.vpc_id

  dynamic ingress {
    for_each = var.ec2_ingress_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
