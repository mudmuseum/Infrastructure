module "security-group-mudmuseum_com" {
  source = "../../modules/security-group"

  security_group_name = var.security_group_name
  ec2_ingress_ports = var.ec2_ingress_ports
}
