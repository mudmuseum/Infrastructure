resource "aws_security_group" "security-group" {

  name = var.security_group_name

  dynamic ingress {
    for_each = var.ec2_ingress_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }
}
