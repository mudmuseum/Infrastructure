variable "asg_name" {
  description = "The name for the AutoScaling Group."
  default     = "asg-1-mudmuseum_com"
}

variable "lc_name" {
  description = "The name for the Launch Config."
  default     = "lc-1-mudmuseum_com"
}

variable "image_id" {
  description = "The Image ID for the EC2 instance launched via ASG-LT."
  default     = "ami-015f1226b535bd02d"
}

variable "instance_type" {
  description = "The instance type."
  default     = "t4g.micro"
}

variable "root_block_device_volume_size" {
  description = "Volume size for root block volume."
  default = "8"
}

variable "root_block_device_volume_type" {
  description = "Volume type for root block volume."
  default = "gp2"
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
