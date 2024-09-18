resource "aws_s3_object" "object" {
    bucket = var.s3_bucket
    key = var.key
}