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
  value = module.directory_for_ubuntu_package.id
}


output "package_s3_bucket_ubuntu_key" {
  value = module.directory_for_ubuntu_package.key
}

output "package_s3_bucket_ubuntu_metadata" {
  value = module.directory_for_ubuntu_package.metadata
}

output "naimagebuilder_component_uri" {
  value = "s3://${module.package_s3_bucket.id}/${module.directory_for_ubuntu_package.key}abc.png"
}