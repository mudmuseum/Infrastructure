output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc_base_infrastructure_mudmuseum_com.vpc_id 
}

output "public_subnet_id" {
  description = "Public Subnet ID."
  value       = module.vpc_base_infrastructure_mudmuseum_com.public_subnet_id
}
