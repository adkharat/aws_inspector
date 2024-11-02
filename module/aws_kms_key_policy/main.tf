resource "aws_kms_key_policy" "kms_key_policy" {
  key_id = var.key_id
  policy = var.policy_json
}