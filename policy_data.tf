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

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_lifecycle_policy
data "aws_iam_policy_document" "execution_role_for_lifecycle_policy_assume_role" {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["imagebuilder.${data.aws_partition.current.dns_suffix}"]
    }
  }
}