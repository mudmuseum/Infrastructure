output "name" {
  description = "ASG name"
  value       = aws_autoscaling_group.asg-lc-ec2.id
}
