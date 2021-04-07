output "iam_instance_profile_name" {
  description = "The IAM Instance Profile name."
  value       = module.ec2_instance_profile.profile_name
}
