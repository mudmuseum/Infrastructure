data "aws_ami" "amazon_linux_2" {
  most_recent                   = true

  filter {
    name                        = "name"
    values                      = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name                        = "virtualization-type"
    values                      = ["hvm"]
  }

  owners                        = ["amazon"]
}

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
  source      = "github.com/mudmuseum/terraform-modules.git//modules/iam_policy?ref=v0.1.5"

  name        = "ECR_Push_Images"
  description = "Allows pushing images"
  policy      = data.aws_iam_policy_document.iam_policy_document_push_to_ecr.json
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

module "iam_role" {
  source             = "github.com/mudmuseum/terraform-modules.git//modules/iam_role?ref=v0.1.5"

  role_name          = "ECR_Push_Images_Instance_Role"
  assume_role_policy = data.aws_iam_policy_document.iam_policy_document_assume_role.json
}

module "ec2_instance_profile" {
  source       = "github.com/mudmuseum/terraform-modules.git//modules/iam_instance_profile?ref=v0.1.5"

  profile_name = "ECR_Push_Images_Instance_Profile"
  role_name    = module.iam_role.role_name
}

module "iam_role_policy_attachment" {
  source       = "github.com/mudmuseum/terraform-modules.git//modules/iam_role_policy_attachment?ref=v0.1.5"

  role_name    = module.iam_role.role_name
  policy_arn   = module.iam_policy_push_to_ecr.policy_arn
}

module "ec2_1_mudmuseum_com" {
  source = "github.com/mudmuseum/terraform-modules.git//modules/ec2_instance?ref=v0.1.2"

  ami                           = data.aws_ami.amazon_linux_2.id
  instance_type                 = var.instance_type
  root_block_device_volume_size = var.root_block_device_volume_size
  root_block_device_volume_type = var.root_block_device_volume_type
  key_name                      = var.key_name
  security_group_id             = var.security_group_id
  subnet_id                     = var.subnet_id
  iam_instance_profile          = module.ec2_instance_profile.profile_name
}

module "elastic_ip" {
  source                        = "github.com/mudmuseum/terraform-modules.git//modules/elastic_ip?ref=v0.1.2"

  instance                      = module.ec2_1_mudmuseum_com.id
}

module "route53_zone" {
  source                        = "github.com/mudmuseum/terraform-modules.git//modules/route53_zone?ref=v0.1.2"

  route53_zone_name             = var.route53_zone_name
}

module "route53_record" {
  source = "github.com/mudmuseum/terraform-modules.git//modules/route53_record?ref=v0.1.2"

  route53_zone_id               = module.route53_zone.id
  route53_record_name           = var.route53_record_name
  route53_record_type           = var.route53_record_type
  route53_record_ttl            = var.route53_record_ttl
  route53_record_value          = [ module.elastic_ip.elastic_ip ]
}
