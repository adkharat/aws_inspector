resource "aws_kms_key" "aws_kms_key"{
    description = var.kms_key_description
    key_usage = var.kms_key_key_usage
    policy = var.aws_kms_key_policy
}