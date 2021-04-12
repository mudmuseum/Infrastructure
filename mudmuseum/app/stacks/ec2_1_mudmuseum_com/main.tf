################################################################
#                                                              #
# Terraform Remote State from Persistent Stacks Repository     #
#                                                              #
# https://github.com/mudmuseum/terraform-persistent-stacks.git #
#                                                              #
################################################################

data "terraform_remote_state" "vpc_base_infrastructure_mudmuseum" {
  backend = "s3"

  config = {
    bucket         = "<%= expansion('terraform-state-:ACCOUNT-:REGION-:ENV') %>"
    key            = "<%= expansion(':REGION/:ENV/stacks/vpc_base_infrastructure_mudmuseum/terraform.tfstate') %>"
    region         = "<%= expansion(':REGION') %>"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}

data "terraform_remote_state" "key_pair_mudmuseum" {
  backend = "s3"

  config = {
    bucket         = "<%= expansion('terraform-state-:ACCOUNT-:REGION-:ENV') %>"
    key            = "<%= expansion(':REGION/:ENV/stacks/key_pair_mudmuseum/terraform.tfstate') %>"
    region         = "<%= expansion(':REGION') %>"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}

data "terraform_remote_state" "security_group_mudmuseum" {
  backend = "s3"

  config = {
    bucket         = "<%= expansion('terraform-state-:ACCOUNT-:REGION-:ENV') %>"
    key            = "<%= expansion(':REGION/:ENV/stacks/security_group_mudmuseum/terraform.tfstate') %>"
    region         = "<%= expansion(':REGION') %>"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}

data "terraform_remote_state" "route53_zone_mudmuseum" {
  backend = "s3"

  config = {
    bucket         = "<%= expansion('terraform-state-:ACCOUNT-:REGION-:ENV') %>"
    key            = "<%= expansion(':REGION/:ENV/stacks/route53_zone_mudmuseum/terraform.tfstate') %>"
    region         = "<%= expansion(':REGION') %>"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}

#######################################################
#                                                     #
# Using data block to import AWS AMI for EC2 Instance #
#                                                     #
#######################################################

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

##############################################################
#                                                            #
# Data block to get User Account for IAM Policy Resource ARN #
#                                                            #
##############################################################

data "aws_caller_identity" "current" {}

#############################################################
#                                                           #
# IAM Policy for EC2 Instance Profile to push Images to ECR #
#                                                           #
#############################################################

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

##############################################
#                                            #
# IAM Policy for EC2 Instance STS AssumeRole #
#                                            #
##############################################

data "aws_iam_policy_document" "iam_policy_document_assume_role" {

  statement {
    actions     = [ "sts:AssumeRole" ]
    principals {
      type        = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

#####################################
#                                   #
# IAM Role for EC2 Instance Profile #
#                                   #
#####################################

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

################
#              #
# EC2 Instance #
#              #
################

module "ec2_1_mudmuseum_com" {
  source = "github.com/mudmuseum/terraform-modules.git//modules/ec2_instance?ref=v0.1.5"

  ami                           = data.aws_ami.amazon_linux_2.id
  instance_type                 = var.instance_type
  root_block_device_volume_size = var.root_block_device_volume_size
  root_block_device_volume_type = var.root_block_device_volume_type
  key_name                      = data.terraform_remote_state.key_pair_mudmuseum.outputs.key_name
  security_group_id             = data.terraform_remote_state.security_group_mudmuseum.outputs.id
  subnet_id                     = data.terraform_remote_state.vpc_base_infrastructure_mudmuseum.outputs.public_subnet_id
  iam_instance_profile          = module.ec2_instance_profile.profile_name
}

###################################################
#                                                 #
# Elastic IP for EC2 Instance                     #
#                                                 #
# See README.md for justification of anti-pattern #
#                                                 #
###################################################

module "elastic_ip" {
  source                        = "github.com/mudmuseum/terraform-modules.git//modules/elastic_ip?ref=v0.1.5"

  ec2_instance                  = module.ec2_1_mudmuseum_com.id
}

#################################
#                               #
# Route53 Record for Elastic IP #
#                               #
#################################

module "route53_record" {
  source = "github.com/mudmuseum/terraform-modules.git//modules/route53_record?ref=v0.1.5"

  route53_zone_id               = data.terraform_remote_state.route53_zone_mudmuseum.outputs.id
  route53_record_name           = var.route53_record_name
  route53_record_type           = var.route53_record_type
  route53_record_ttl            = var.route53_record_ttl
  route53_record_value          = [ module.elastic_ip.elastic_ip ]
}
