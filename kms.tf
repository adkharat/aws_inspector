module "kms" {
  source              = "./module/aws_kms_key"
  kms_key_description = var.ebs_kms_description
  kms_key_key_usage   = var.ebs_kms_key_usage
  aws_kms_key_policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        },
        "Action": "kms:*",
        "Resource": "*"
      }
    ]
  }
  )
  multi_region = true
}

module "kms_alias" {
  depends_on = [ module.kms ]

  source = "./module/aws_kms_alias"
  kms_alias_name = "alias/golden-kms-key-alias"
  target_kms_key_id = module.kms.arn
}