variable "vpc_cidr_block" {
  description = "VPC CIDR Block."
  default     = "10.0.0.0/16"
}

variable "vpc_tag_name" {
  description = "Tag 'Name' association for the VPC."
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet CIDR Block."
  default     = "10.0.0.0/24"
}

variable "public_subnet_availability_zone" {
  description = "Public Subnet Availability Zone."
  default     = "us-east-1a"
}

variable "public_subnet_tag_name" {
  description = "Tag 'Name' association for the Public Subnet."
}

variable "internet_gateway_tag_name" {
  description = "Tag 'Name' association for the Internet Gateway."
}

variable "route_table_public_cidr_block" {
  description = "Route Table Public CIDR Block."
  default     = "0.0.0.0/0"
}

variable "route_table_ipv6_public_cidr_block" {
  description = "Route table Public CIDR Block for IPv6."
  default     = "::/0"
}

variable "route_table_tag_name" {
  description = "Tag 'Name' association for the Route Table."
}
