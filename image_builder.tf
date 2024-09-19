module "imagebuilder_component_for_ubuntu" {
  depends_on = [ module.package_s3_bucket, module.directory_for_ubuntu_package ]
  
  source = "./module/aws_imagebuilder_component"
  imagebuilder_component_name = "imagebuilder_component_for_ubuntu"
  imagebuilder_component_platform = "Linux"
  imagebuilder_component_uri = "s3://${module.package_s3_bucket.id}/${module.directory_for_ubuntu_package.key}" //key (yaml file) must be less than 64 KB
  imagebuilder_component_version = "1.0.0"
  supported_os_versions = ["Ubuntu 24.04"]
}

module "image_recipe_for_ubuntu" {
  depends_on = [ module.imagebuilder_component_for_ubuntu ]

  source = "./module/aws_imagebuilder_image_recipe"
  imagebuilder_image_recipe_name = "image_recipe_for_ubuntu"
  imagebuilder_image_recipe_version = "1.0.0"
  imagebuilder_image_recipe_parent_image = "ami-0e86e20dae9224db8"
  imagebuilder_image_recipe_block_device_mapping_device_name = "/dev/xvdb" //  /dev/sda or /dev/xvdb.
  imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination = true
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_size = 10
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_type = "io1" // gp2 or io2.
  imagebuilder_image_recipe_block_device_mapping_ebs_iops = 100
  imagebuilder_image_recipe_component_arn = module.imagebuilder_component_for_ubuntu.arn
  uninstall_systems_manager_agent_after_build = false
  user_data_base64 = base64encode(file("./scripts/ubuntu_bootstrap.sh"))
  working_directory = "/workspace"
}

module "imagebuilder_infrastructure_configuration" {
    depends_on = [ module.image_builder_infra_config_role_attachment_instance_profile ]

    source = "./module/aws_imagebuilder_infrastructure_configuration"
    imagebuilder_infrastructure_configuration_name = "imagebuilder_ec2_infrastructure"
    imagebuilder_infrastructure_configuration_description = "imagebuilder_ec2_infrastructure"
    imagebuilder_infrastructure_configuration_instance_profile_name = module.image_builder_infra_config_role_attachment_instance_profile.name
    imagebuilder_infrastructure_configuration_instance_types = ["t2.micro"]
    imagebuilder_infrastructure_configuration_security_group_ids = [module.ssh_sg.id, module.http_sg.id, module.https_sg.id]
    imagebuilder_infrastructure_configuration_terminate_instance_on_failure = true
    imagebuilder_infrastructure_configuration_s3_logs = module.imagebuilder_ec2_infra_logs.id
    imagebuilder_infrastructure_configuration_s3_key_prefix = "logs"
}

module "ubuntu_distribution" {
  source = "./module/aws_imagebuilder_distribution_configuration"
  imagebuilder_distribution_configuration_name = "ubuntu-ami-dis-conf"
  imagebuilder_distribution_ami_tag = {image = "ubuntu"}
  ami_distribution_name = "ubuntu-ami-dist"
  user_ids = local.account_id
  region = "us-east-1"
}

module "imagebuilder_ubuntu_image" {
  depends_on = [ module.ubuntu_distribution, module.image_recipe_for_ubuntu, module.imagebuilder_infrastructure_configuration ]
  
  source = "./module/aws_imagebuilder_image"
  imagebuilder_image_distribution_configuration_arn = module.ubuntu_distribution.arn
  imagebuilder_image_image_recipe_arn = module.image_recipe_for_ubuntu.arn
  imagebuilder_image_infrastructure_configuration_arn = module.imagebuilder_infrastructure_configuration.arn
}

//run every Friday morning at 8 am UTC. Enabled testing of the image and setting a timeout of 60 minutes.
module "imagebuilder_ubuntu_image_pipeline" {
  depends_on = [ module.image_recipe_for_ubuntu, module.imagebuilder_infrastructure_configuration, module.ubuntu_distribution ]

  source = "./module/aws_imagebuilder_image_pipeline"
  imagebuilder_image_pipeline_name = "ubuntu_image_pipeline"
  imagebuilder_image_pipeline_description = "ubuntu_image_pipeline"
  imagebuilder_image_pipeline_image_recipe_arn = module.image_recipe_for_ubuntu.arn
  distribution_configuration_arn = module.ubuntu_distribution.arn
  imagebuilder_image_pipeline_infrastructure_configuration_arn = module.imagebuilder_infrastructure_configuration.arn
  imagebuilder_image_pipeline_status = "ENABLED"
  imagebuilder_image_pipeline_schedule_expression = "cron(50 11 19 9 ? 2024)" //run every Friday at 8 AM. cron(0 8 ? * FRI *)
  magebuilder_image_pipeline_timezone = "UTC" //defaults to UTC //https://www.joda.org/joda-time/timezones.html
  imagebuilder_image_pipeline_pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE" //Possible values : EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE and EXPRESSION_MATCH_ONLY
  imagebuilder_image_pipeline_image_tests_enabled = true
  imagebuilder_image_pipeline_timeout_minutes = 60
  image_scanning_enabled = true
}



