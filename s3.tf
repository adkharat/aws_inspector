module "package_s3_bucket" {
  source = "./module/aws_s3_bucket"
  s3_bucket_name = var.package_s3_bucket_name
#   s3_bucket_prefix = var.package_s3_bucket_prefix
}

module "s3_bucket_versioning" {
  source = "./module/aws_s3_bucket_versioning"
  s3_bucket_name = module.package_s3_bucket.id
}

# module "bucket_access_control" {
#   source = "./module/aws_s3_bucket_acl"
#   s3_bucket_acl_bucket = module.package_s3_bucket.id
#   s3_bucket_acl_acl = "private"
# }

module "directory_for_amazon_ami_package" {
  source = "./module/aws_s3_object"
  s3_bucket = module.package_s3_bucket.id
  key = "amazon/amazonamiconfig.yaml"
  sourcepath = "./scripts/amazonamiconfig.yaml"
}

module "directory_for_ubuntu_package" {
  source = "./module/aws_s3_object"
  s3_bucket = module.package_s3_bucket.id
  key = "ubuntu/ubuntuconfig.yaml"
  sourcepath = "./scripts/ubuntuconfig.yaml"
}

module "directory_for_window_package" {
  source = "./module/aws_s3_object"
  s3_bucket = module.package_s3_bucket.id
  key = "window/windowsconfig.yaml"
  sourcepath = "./scripts/windowsconfig.yaml"
}