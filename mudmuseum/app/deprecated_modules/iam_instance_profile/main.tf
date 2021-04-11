resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = var.profile_name
  role = var.role_name
}
