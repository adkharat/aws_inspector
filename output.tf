output "package_s3_bucket_arn" {
  value = module.package_s3_bucket.arn
}

output "package_s3_bucket_id_or_name" {
  value = module.package_s3_bucket.id
}

output "package_s3_bucket_domain_name" {
  value = module.package_s3_bucket.bucket_domain_name
}

output "package_s3_bucket_ubuntu_id" {
  value = module.component_for_ubuntu_package.id
}


output "package_s3_bucket_ubuntu_key" {
  value = module.component_for_ubuntu_package.key
}

output "package_s3_bucket_ubuntu_metadata" {
  value = module.component_for_ubuntu_package.metadata
}

output "account_id" {
  value = local.account_id
}


output "current_user_id" {
  value = local.current_user_id
}

output "current_id" {
  value = local.current_id
}

output "current_arn" {
  value = local.current_arn
}

output "iam_users_list" {
  value = local.iam_users
}

output "az_0" {
  value = data.aws_availability_zones.available.names[0]
}

output "az_1" {
  value = data.aws_availability_zones.available.names[1]
}

output "nat_gateway_public_ip" {
  value = module.elastic_ip.public_ip
}

output "kms_key_id" {
  value = module.kms.key_id
}

output "kms_id" {
  value = module.kms.id
}

output "kms_arn" {
  value = module.kms.arn
}

output "kms_alias_name" {
  value = module.kms_alias.kms_alias_name
}

output "kms_alias_name_prefix" {
  value = module.kms_alias.kms_alias_name_prefix
}

output "kms_alias_target_key_id" {
  value = module.kms_alias.target_key_id
}

output "kms_alias_arn" {
  value = module.kms_alias.kms_alias_arn
}

output "kms_alias_id" {
  value = module.kms_alias.kms_alias_id
}

output "current_partition" {
  value = data.aws_partition.current
}

output "current_partition_dns_suffix" {
  value = data.aws_partition.current.dns_suffix
}