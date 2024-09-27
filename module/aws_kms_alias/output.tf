output "arn" {
  value = aws_kms_alias.kms_alias.arn
}

output "target_key_arn" {
  value = aws_kms_alias.kms_alias.target_key_arn
}

output "target_key_id" {
  value = aws_kms_alias.kms_alias.target_key_id
}