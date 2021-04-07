variable "instance_type" {
  description = "The instance type."
  default     = "t4g.micro"
}

variable "root_block_device_volume_size" {
  description = "Volume size for root block volume."
  default     = "8"
}

variable "root_block_device_volume_type" {
  description = "Volume type for root block volume."
  default     = "gp2"
}

variable "route53_zone_name" {
  description = "Route53 zone name for EIP configuration."
  default     = "mudmuseum.com"
}

variable "route53_record_name" {
  description = "Route53 record name for EIP configuration."
  default     = "mud.mudmuseum.com"
}

variable "route53_record_type" {
  description = "Route53 record type, e.g. A record."
  default     = "A"
}

variable "route53_record_ttl" {
  description = "Route53 record TTL."
  default     = "3600"
}

variable "key_name" {
  description = "Public SSH-Key to log into the EC2 instance."
}

variable "security_group_id" {
  description = "Security Group ID to associate."
}

variable "subnet_id" {
  description = "Subnet ID to place the EC2 instance into."
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile for the EC2 instance."
}
