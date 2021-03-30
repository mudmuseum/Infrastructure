variable "instance_type" {
  description = "The instance type for the EC2 instance."
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

variable "associate_public_ip_address" {
  description = "Choose whether to associate a public ip or not."
  default     = false
}

variable "key_name" {
  description = "The name of the public key for accessing the EC2 instance."
  default     = "ec2-mudmuseum_com"
}

variable "security_group_ids" {
  description = "The list of security group IDs to associate to the EC2 instance."
  type        = list
}
