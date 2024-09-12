module "ebs_kms" {
  source              = "./module/aws_kms_key"
  kms_key_description = var.ebs_kms_description
  kms_key_key_usage   = var.ebs_kms_key_usage
}