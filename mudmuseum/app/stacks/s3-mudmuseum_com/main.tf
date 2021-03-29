module "s3-mudmuseum_com" {
  source     = "../../modules/s3"
  bucket     = "mudmuseum.com"
  logging_target_bucket = "mudmuseum-logs"
  logging_target_prefix = "mudmuseum-s3-bucket-server-access-logging"

  force_destroy = var.force_destroy
}
