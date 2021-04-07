output "role_name" {
  description = "The AWS IAM Role name."
  value       = aws_iam_role.iam_role.name
}
