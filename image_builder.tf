# module "imagebuilder_component_for_ubuntu" {
#   depends_on = [ module.package_s3_bucket, module.directory_for_ubuntu_package ]
  
#   source = "./module/aws_imagebuilder_component"
#   imagebuilder_component_name = "imagebuilder_component_for_ubuntu"
#   imagebuilder_component_platform = "Linux"
#   imagebuilder_component_uri = "s3://${module.package_s3_bucket.id}/${module.directory_for_ubuntu_package.key}" //key (yaml file) must be less than 64 KB
#   imagebuilder_component_version = "1.0.0"
#   supported_os_versions = ["Ubuntu 24.04"]
# }

# module "image_recipe_for_ubuntu" {
#   source = "./module/aws_imagebuilder_image_recipe"
#   imagebuilder_image_recipe_name = "image_recipe_for_ubuntu"
#   imagebuilder_image_recipe_version = "1.0.0"
#   imagebuilder_image_recipe_parent_image = "ami-0e86e20dae9224db8"
#   imagebuilder_image_recipe_block_device_mapping_device_name = "image_recipe_for_ubuntu_block_device_mapping"
#   imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination = true
#   imagebuilder_image_recipe_block_device_mapping_ebs_volume_size = 10
#   imagebuilder_image_recipe_block_device_mapping_ebs_volume_type = "io1"
#   imagebuilder_image_recipe_component_arn = module.imagebuilder_component_for_ubuntu.arn
#   uninstall_systems_manager_agent_after_build = false
#   user_data_base64 = base64encode(file("./scripts/ubuntu_bootstrap.sh"))
#   working_directory = "/workspace"
# }

# module "imagebuilder_infrastructure_configuration" {
#     source = "./module/aws_imagebuilder_infrastructure_configuration"
#     imagebuilder_infrastructure_configuration_name = "imagebuilder_ec2_infrastructure"
#     imagebuilder_infrastructure_configuration_description = "imagebuilder_ec2_infrastructure"
#     imagebuilder_infrastructure_configuration_instance_profile_name = module.image_builder_infra_config_role_attachment_instance_profile.name
#     imagebuilder_infrastructure_configuration_instance_types = ["t2.micro"]
#     imagebuilder_infrastructure_configuration_security_group_ids = [module.ssh_sg.id, module.http_sg.id, module.https_sg.id]
#     imagebuilder_infrastructure_configuration_terminate_instance_on_failure = true
#     imagebuilder_infrastructure_configuration_s3_logs = module.imagebuilder_ec2_iinfra_logs.id
#     imagebuilder_infrastructure_configuration_s3_key_prefix = "logs"
# }