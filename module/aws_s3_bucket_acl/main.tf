//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
    bucket = var.s3_bucket_acl_bucket
    acl = var.s3_bucket_acl_acl
}