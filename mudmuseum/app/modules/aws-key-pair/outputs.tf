output "key_name" {
  description = "Key Pair name." 
  value       = aws_key_pair.ec2-instance.key_name
}
