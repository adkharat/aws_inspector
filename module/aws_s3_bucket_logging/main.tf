resource "aws_s3_bucket_logging" "golden_s3_bucket_logging" {
  bucket = var.source_bucket_id

  target_bucket = var.target_bucket_id
  target_prefix = var.target_prefix
}