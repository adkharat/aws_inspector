# https://docs.aws.amazon.com/kms/latest/developerguide/alias-authorization.html
data "aws_iam_policy_document" "ec2_s3_data_decrypt_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = [module.kms.arn]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "kms:ResourceAliases"
      values   = [module.kms_alias.kms_alias_name]
    }
  }
}