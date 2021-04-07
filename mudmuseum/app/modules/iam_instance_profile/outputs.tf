output "profile_name" {
  description = "IAM Instance Profile name."
  value       = aws_iam_instance_profile.iam_instance_profile.name
}
