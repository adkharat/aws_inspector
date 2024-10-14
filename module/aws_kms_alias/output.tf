output "kms_alias_arn" {
  value = aws_kms_alias.kms_alias.arn
}

output "target_key_arn" {
  value = aws_kms_alias.kms_alias.target_key_arn
}

output "target_key_id" {
  value = aws_kms_alias.kms_alias.target_key_id
}

output "kms_alias_name" {
  value = aws_kms_alias.kms_alias.name
}


output "kms_alias_name_prefix" {
  value = aws_kms_alias.kms_alias.name_prefix
}

output "kms_alias_id" {
  value = aws_kms_alias.kms_alias.id
}