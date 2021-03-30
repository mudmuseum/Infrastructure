output "public_ip_mudmuseum_com" {
  description = "Public IP (EIP) assigned to MudMuseum.com server."
  value = aws_eip.public_ip_mudmuseum_com.public_ip
}
