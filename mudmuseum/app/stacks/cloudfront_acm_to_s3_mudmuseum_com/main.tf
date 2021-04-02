module "cloudfront_acm_to_s3_mudmuseum_com" {
  source  = "../../modules/cloudfront_acm_to_s3"

  comment = "access-identity-"
  cloudfront_origin_origin_id = "S3-mudmuseum.com"

  bucket                = "mudmuseum.com"
  logging_target_bucket = "mudmuseum-logs"
  logging_target_prefix = "mudmuseum-s3-bucket-server-access-logging"
  force_destroy         = false

  acm_domain_name               = "mudmuseum.com"
  acm_subject_alternative_names = ["web.mudmuseum.com", "www.mudmuseum.com"]
  acm_validation_method         = "DNS"

  cloudfront_logging_bucket = "mudmuseum-logs.s3.amazonaws.com"
  cloudfront_logging_prefix = "logdir/"
  cloudfront_aliases        = ["mudmuseum.com", "web.mudmuseum.com", "www.mudmuseum.com"]
}
