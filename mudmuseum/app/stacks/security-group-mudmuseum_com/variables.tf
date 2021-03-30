variable "security_group_name" {
  description = "Name of the Security Group."
  default     = "security-group-mudmuseum_com"
}

variable "ec2_ingress_ports" {
  description = "The ingress ports for EC2."
  type        = map
  default     = {
    "22"  = ["198.54.129.68/32"]
    "9000" = ["0.0.0.0/0"]
  }
}
