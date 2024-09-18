//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "s3_bucket" {
    bucket = var.s3_bucket_name
    # bucket_prefix = var.s3_bucket_prefix 
}