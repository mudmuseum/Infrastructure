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
    resources   = [ "arn:aws:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/mudmuseum" ]
  }
  statement {
    actions     = [ "ecr:GetAuthorizationToken" ]
    resources   = [ "arn:aws:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/mudmuseum" ]
  }
}

data "aws_iam_policy_document" "iam_policy_document_assume_role" {

  statement {
    actions     = [ "sts:AssumeRole" ]
    principals {
      type        = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

module "iam_policy_push_to_ecr" {
  source      = "../../modules/iam_policy"

  name        = "ECR_Push_Images"
  description = "Allows pushing images"
  policy      = data.aws_iam_policy_document.iam_policy_document_push_to_ecr.json
}

module "iam_role" {
  source             = "../../modules/iam_role"

  role_name          = "ECR_Push_Images_Instance_Role"
  assume_role_policy = data.aws_iam_policy_document.iam_policy_document_assume_role.json
}

module "ec2_instance_profile" {
  source       = "../../modules/iam_instance_profile"

  profile_name = "ECR_Push_Images_Instance_Profile"
  role_name    = module.iam_role.role_name
}

module "iam_role_policy_attachment" {
  source       = "../../modules/iam_role_policy_attachment"

  role_name    = module.iam_role.role_name
  policy_arn   = module.iam_policy_push_to_ecr.policy_arn
}
