data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iam_policy_document_push_to_ecr" {

  statement {
    actions     = [ "ecr:DescribeImageScanFindings",
                    "ecr:StartImageScan",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:ListTagsForResource",
                    "ecr:UploadLayerPart",
                    "ecr:ListImages",
                    "ecr:PutImage",
                    "ecr:UntagResource",
                    "ecr:BatchGetImage",
                    "ecr:CompleteLayerUpload",
                    "ecr:DescribeImages",
                    "ecr:TagResource",
                    "ecr:DescribeRepositories",
                    "ecr:InitiateLayerUpload",
                    "ecr:BatchCheckLayerAvailability" ]

    resources   = [ "arn:aws:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/*" ]
  }
  statement {
    actions     = [ "ecr:GetAuthorizationToken" ]
    resources   = [ "*" ]
  }
}

module "iam_policy_push_to_ecr" {
  source      = "../../modules/iam_policy"

  name        = "ECR_Push_Images"
  description = "Allows pushing images"
  policy      = data.aws_iam_policy_document.iam_policy_document_push_to_ecr.json
}
