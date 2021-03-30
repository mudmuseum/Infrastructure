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
