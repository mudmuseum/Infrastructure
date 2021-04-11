variable "ec2_ingress_ports" {
  description = "Open EC2 ingress ports in Security Group."
  type = map
}

variable "security_group_name" {
  description = "The name of the Security Group."
}

variable "vpc_id" {
  description = "The VPC ID for the Security Group."
}
