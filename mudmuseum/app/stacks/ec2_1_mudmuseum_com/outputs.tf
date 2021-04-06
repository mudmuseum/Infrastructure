output "public_ip_mudmuseum_com" {
  description = "Public IP (EIP) assigned to MudMuseum.com server."
  value       = module.ec2_1_mudmuseum_com.public_ip_mudmuseum_com
}
