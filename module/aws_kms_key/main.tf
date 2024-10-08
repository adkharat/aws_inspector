//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "aws_kms_key"{
    description = var.kms_key_description
    key_usage = var.kms_key_key_usage
    policy = var.aws_kms_key_policy
}