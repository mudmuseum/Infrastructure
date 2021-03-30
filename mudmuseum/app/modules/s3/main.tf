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
