# data "aws_iam_policy_document" "iam_policy_document" {

#  statement {
#    actions   = var.actions
#    resources = var.resources
#  }
#}

resource "aws_iam_policy" "iam_policy" {
  name        = var.name
  description = var.description

#  policy = data.aws_iam_policy_document.iam_policy_document.json
  policy      = var.policy
}
