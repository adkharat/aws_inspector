//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "kms_alias" {
  name          = var.kms_alias_name
  target_key_id = var.target_kms_key_id
}