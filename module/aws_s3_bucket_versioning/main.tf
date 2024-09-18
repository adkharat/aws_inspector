resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = var.s3_bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}