output "public_ip_mudmuseum_com" {
  description = "Public IP (EIP) assigned to MudMuseum.com server."
  value = aws_eip.public_ip_mudmuseum_com.public_ip
}

output "route53_record_mudmuseum_com" {
  description = "A Record entry in Hosted Zone for mudmuseum.com."
  value = aws_route53_record.route53_arecord_mud_mudmuseum_com.fqdn
}
