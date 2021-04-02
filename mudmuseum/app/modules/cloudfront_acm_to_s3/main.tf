data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3-bucket-logging-sse.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "s3-bucket-logging-sse" {
  bucket = var.bucket

  logging {
    target_bucket = var.logging_target_bucket
    target_prefix = var.logging_target_prefix
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  force_destroy = var.force_destroy
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.comment

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_acm_certificate" "acm_certificate" {

  domain_name               = var.acm_domain_name
  subject_alternative_names = var.acm_subject_alternative_names
  validation_method         = var.acm_validation_method

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudfront_cache_policy" "cloudfront_cache_policy" {
  name        = "Managed-CachingOptimized"
  comment     = "Default policy when CF compression is enabled"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  origin {
    domain_name = aws_s3_bucket.s3-bucket-logging-sse.bucket_regional_domain_name
    origin_id   = var.cloudfront_origin_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = var.cloudfront_is_enabled
  is_ipv6_enabled     = var.cloudfront_is_ipv6_enabled
  comment             = var.cloudfront_comment
  default_root_object = var.cloudfront_default_root_object

  logging_config {
    include_cookies = var.cloudfront_logging_include_cookies
    bucket          = var.cloudfront_logging_bucket
    prefix          = var.cloudfront_logging_prefix
  }

  aliases = var.cloudfront_aliases

  default_cache_behavior {
    allowed_methods  = var.cloudfront_cache_allowed_methods
    cached_methods   = var.cloudfront_cache_cached_methods
    target_origin_id = var.cloudfront_origin_origin_id
    cache_policy_id  = aws_cloudfront_cache_policy.cloudfront_cache_policy.id

    viewer_protocol_policy = var.cloudfront_viewer_protocol_policy
    min_ttl                = var.cloudfront_min_ttl
    default_ttl            = var.cloudfront_default_ttl
  }

  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_restriction_type
    }
  }
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.acm_certificate.arn
    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = var.ssl_support_method
  }

  lifecycle {
    prevent_destroy = true
  }
}
