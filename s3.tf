module "package_s3_bucket" {
  depends_on = [ module.kms_alias ]

  source         = "./module/aws_s3_bucket"
  s3_bucket_name = "${var.package_s3_bucket_name}-${random_uuid.uuid.result}"
  kms_key_arn = module.kms_alias.kms_alias_arn
  #   s3_bucket_prefix = var.package_s3_bucket_prefix
  tags = {
    Name        = "${var.package_s3_bucket_name}"
  }
}

module "s3_bucket_versioning" {
  depends_on = [module.package_s3_bucket]

  source         = "./module/aws_s3_bucket_versioning"
  s3_bucket_name = module.package_s3_bucket.id
}

# module "bucket_access_control" {
#   source = "./module/aws_s3_bucket_acl"
#   s3_bucket_acl_bucket = module.package_s3_bucket.id
#   s3_bucket_acl_acl = "private"
# }

module "component_for_amazon_linux_package" {
  depends_on = [module.package_s3_bucket]

  source     = "./module/aws_s3_object"
  s3_bucket  = module.package_s3_bucket.id
  key        = "amazon/amazonamiconfig.yaml"
  sourcepath = "./scripts/amazonamiconfig.yaml"
}

module "bootstrap_shell_script_amazon_linux" {
  depends_on = [module.package_s3_bucket]

  source     = "./module/aws_s3_object"
  s3_bucket  = module.package_s3_bucket.id
  key        = "amazon/amazon_linux_bootstrap.sh"    #remote path
  sourcepath = "./scripts/amazon_linux_bootstrap.sh" #local path
}

module "component_for_ubuntu_package" {
  depends_on = [module.package_s3_bucket]

  source     = "./module/aws_s3_object"
  s3_bucket  = module.package_s3_bucket.id
  key        = "ubuntu/ubuntuconfig.yaml"
  sourcepath = "./scripts/ubuntuconfig.yaml"
}

module "bootstrap_shell_script_ubuntu" {
  depends_on = [module.package_s3_bucket]

  source     = "./module/aws_s3_object"
  s3_bucket  = module.package_s3_bucket.id
  key        = "ubuntu/ubuntu_bootstrap.sh"    #remote path
  sourcepath = "./scripts/ubuntu_bootstrap.sh" #local path
}

module "component_for_window_package" {
  depends_on = [module.package_s3_bucket]

  source     = "./module/aws_s3_object"
  s3_bucket  = module.package_s3_bucket.id
  key        = "window/windowsconfig.yaml"
  sourcepath = "./scripts/windowsconfig.yaml"
}

module "bootstrap_shell_script_windows" {
  depends_on = [module.package_s3_bucket]

  source     = "./module/aws_s3_object"
  s3_bucket  = module.package_s3_bucket.id
  key        = "window/windows_server_bootstrap.ps1"    #remote path
  sourcepath = "./scripts/windows_server_bootstrap.ps1" #local path
}


module "inspectorscaningfile" {
  depends_on = [ module.kms_alias ]

  source         = "./module/aws_s3_bucket"
  s3_bucket_name = "inspectorscaningfile"
  kms_key_arn = module.kms_alias.kms_alias_arn
  #   s3_bucket_prefix = var.package_s3_bucket_prefix
  tags = {
    Name = "inspectorscaningfile"
  }
}


module "golden_s3_bucket_logging" {
  source           = "./module/aws_s3_bucket_logging"
  source_bucket_id = module.package_s3_bucket.id
  target_bucket_id = module.package_s3_bucket.id
  target_prefix    = "log/"
}