output "policy_arn" {
  description = "The IAM Policy ARN."
  value       = aws_iam_policy.iam_policy.arn
}
