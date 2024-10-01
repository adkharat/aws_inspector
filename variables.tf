variable "aws_region" {}
variable "resource_types" {}

variable "amazon_ami_ec2_ami_name" {}
variable "amazon_ami_ec2_instance_type" {}
variable "amazon_ami_ec2_tag" {}
variable "amazon_ami_ec2_volume_type" {}
variable "amazon_ami_ec2_volume_size" {}
variable "amazon_ami_ec2_root_block_device_iops" {}
variable "amazon_ami_ec2_root_block_device_encrypted" {}
variable "amazon_ami_ec2_delete_on_termination" {}
variable "amazon_ami_ec2_associate_public_ip_address" {}
variable "amazon_ami_ec2_user_data" {}

variable "ubuntu_server_ec2_ami_name" {}
variable "ubuntu_server_ec2_instance_type" {}
variable "ubuntu_server_ec2_tag" {}
variable "ubuntu_server_ec2_volume_type" {}
variable "ubuntu_server_ec2_volume_size" {}
variable "ubuntu_server_ec2_root_block_device_iops" {}
variable "ubuntu_server_ec2_root_block_device_encrypted" {}
variable "ubuntu_server_ec2_delete_on_termination" {}
variable "ubuntu_server_ec2_associate_public_ip_address" {}
variable "ubuntu_server_ec2_user_data" {}

variable "windows_server_ec2_ami_name" {}
variable "windows_server_ec2_instance_type" {}
variable "windows_server_ec2_tag" {}
variable "windows_server_ec2_volume_type" {}
variable "windows_server_ec2_volume_size" {}
variable "windows_server_ec2_root_block_device_iops" {}
variable "windows_server_ec2_root_block_device_encrypted" {}
variable "windows_server_ec2_delete_on_termination" {}
variable "windows_server_ec2_associate_public_ip_address" {}
variable "windows_server_ec2_user_data" {}

variable "ebs_kms_description" {}
variable "ebs_kms_key_usage" {}

variable "ssh_sg_security_group_name" {}
variable "ssh_sg_security_group_description" {}
variable "ssh_sg_security_group_ingress_description" {}
variable "ssh_sg_security_group_ingress_to_port" {}
variable "ssh_sg_security_group_ingress_from_port" {}

variable "http_sg_security_group_name" {}
variable "http_sg_security_group_description" {}
variable "http_sg_security_group_ingress_description" {}
variable "http_sg_security_group_ingress_to_port" {}
variable "http_sg_security_group_ingress_from_port" {}

variable "https_sg_security_group_name" {}
variable "https_sg_security_group_description" {}
variable "https_sg_security_group_ingress_description" {}
variable "https_sg_security_group_ingress_to_port" {}
variable "https_sg_security_group_ingress_from_port" {}


variable "ssm_role_name" {}
variable "ssm_iam_instance_profile_name" {}
variable "image_builder_infra_config_role_name" {}
variable "image_builder_infra_config_iam_policy_arn" {}

variable "package_s3_bucket_name" {}
# variable "package_s3_bucket_prefix" {}

variable "ubuntu_imagebuilder_image_recipe_name" {}
variable "amazon_linux_imagebuilder_image_recipe_name" {}
variable "windows_imagebuilder_image_recipe_name" {}

variable "imagebuilder_component_platform" {
  type    = string
  default = "Linux"  # Set default to Linux, adjust as needed
}