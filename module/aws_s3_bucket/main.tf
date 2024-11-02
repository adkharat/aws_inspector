//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "s3_bucket" {
    bucket = var.s3_bucket_name
    # bucket_prefix = var.s3_bucket_prefix 
    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "aws:kms"
          kms_master_key_id = var.kms_key_arn
        }
      }
    }
    tags = var.tags
}