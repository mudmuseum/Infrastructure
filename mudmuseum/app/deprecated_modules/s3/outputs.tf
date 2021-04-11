output "name" {
  description = "Bucket name"
  value       = aws_s3_bucket.s3-bucket-logging-sse.id
}
