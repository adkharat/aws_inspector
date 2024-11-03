resource "random_uuid" "uuid" {}

data "aws_s3_bucket" "script_bucket" {
  bucket = module.package_s3_bucket.id
}