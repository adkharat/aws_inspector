module "imagebuilder_component_for_windows" {
  depends_on = [ module.package_s3_bucket, module.component_for_window_package, module.kms ]
  
  source = "./module/aws_imagebuilder_component"
  imagebuilder_component_name = "imagebuilder_component_for_window_ami"
  imagebuilder_component_platform = "Windows"
  imagebuilder_component_uri = "s3://${module.package_s3_bucket.id}/${module.component_for_window_package.key}" //key (yaml file) must be less than 64 KB
  imagebuilder_component_version = "1.0.0"
  supported_os_versions = ["Microsoft Windows Server 2022"]
  kms_key_id = module.kms.arn
  # imagebuilder_component_uri = yamlencode({
  #   phases = [{
  #     name = "build"
  #     steps = [{
  #       action = "ExecutePowerShell"
  #       inputs = {
  #         commands = ["Write-Output 'imagebuilder_component_windows'"]
  #       }
  #       name      = "imagebuilder_component"
  #       onFailure = "Continue"
  #     }]
  #   }]
  #   schemaVersion = 1.0
  # })

  tags = {
    "Name" = "imagebuilder_component_for_windows"
  }
}

module "image_recipe_for_windows" {
  depends_on = [ module.imagebuilder_component_for_windows, module.kms ]

  source = "./module/aws_imagebuilder_image_recipe"
  imagebuilder_image_recipe_name = var.windows_imagebuilder_image_recipe_name
  imagebuilder_image_recipe_version = "1.0.0"
  imagebuilder_image_recipe_parent_image = "ami-0a72c1cec9779f01a" //AMI ID is region specific
  imagebuilder_image_recipe_block_device_mapping_device_name = "/dev/xvdb" //  /dev/sda or /dev/xvdb.
  imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination = true
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_size = 10
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_type = "io1" // gp2 or io2.
  imagebuilder_image_recipe_block_device_mapping_ebs_iops = 100
  imagebuilder_image_recipe_component_arn = module.imagebuilder_component_for_windows.arn
  uninstall_systems_manager_agent_after_build = false
  user_data_base64 = base64encode(file("./scripts/windows_server_bootstrap.ps1"))
  working_directory = "C:/"
  imagebuilder_component_platform = "Windows"
  kms_key_id = module.kms.arn
  tags = {
    "Name" = "image_recipe_for_windows_server"
  }
}


module "windows_distribution" {
  depends_on = [ module.kms ]

  source = "./module/aws_imagebuilder_distribution_configuration"
  imagebuilder_distribution_configuration_name = "windows-server-ami-dis-conf"
  imagebuilder_distribution_configuration_description = "windows-server-ami-dis-conf-discription"
  imagebuilder_distribution_ami_tag = {image = "windows-server"}
  ami_distribution_name = "windows-server-ami-dist"
  # kms_key_id = module.kms.arn
  user_ids = local.account_id
  target_account_ids = local.account_id
  region = var.aws_region
  tags = {
      "Name" = "imagebuilder_windows_server_distribution"
  }
}

module "imagebuilder_windows_image_pipeline" {
  depends_on = [ module.image_recipe_for_windows, module.imagebuilder_infrastructure_configuration, module.windows_distribution, module.image_builder_workflow, module.inspector2_enabler]

  source = "./module/aws_imagebuilder_image_pipeline"
  imagebuilder_image_pipeline_name = "windows_server_image_pipeline"
  imagebuilder_image_pipeline_description = "windows_server_image_pipeline"
  imagebuilder_image_pipeline_image_recipe_arn = module.image_recipe_for_windows.arn
  distribution_configuration_arn = module.windows_distribution.arn
  execution_role_to_execute_workflow = module.aws_service_role_for_image_builder_role.arn //AWS managed role AWSServiceRoleForImageBuilder
  workflow_arn = module.image_builder_workflow.arn
  imagebuilder_image_pipeline_infrastructure_configuration_arn = module.imagebuilder_infrastructure_configuration.arn
  imagebuilder_image_pipeline_status = "ENABLED"
  imagebuilder_image_pipeline_schedule_expression = "cron(0 10 * * ? *)" //Run daily at 10:00 AM
  magebuilder_image_pipeline_timezone = "UTC" //defaults to UTC //https://www.joda.org/joda-time/timezones.html
  imagebuilder_image_pipeline_pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY" //Possible values : EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE and EXPRESSION_MATCH_ONLY
  imagebuilder_image_pipeline_image_tests_enabled = true
  imagebuilder_image_pipeline_timeout_minutes = 60
  image_scanning_enabled = true
  tags = {
      "Name" = "imagebuilder_windows_server_image_pipeline"
  }
}

module "ssm_association_windows" {
  source = "./module/aws_ssm_association"

  ssm_association_document_name = "AWS-GatherSoftwareInventory"
  ssm_association_instance_key = "tag:Name"
  ssm_association_instance_id = ["Test instance for ${var.windows_imagebuilder_image_recipe_name}"]

  tags = {
      "Name" = "ssm_association_windows_server"
  }
}
