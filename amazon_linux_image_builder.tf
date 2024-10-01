module "imagebuilder_component_for_amazon_linux" {
  depends_on = [ module.package_s3_bucket, module.directory_for_amazon_ami_package, module.kms ]
  
  source = "./module/aws_imagebuilder_component"
  imagebuilder_component_name = "imagebuilder_component_for_amazon_ami"
  imagebuilder_component_platform = "Linux"
  # imagebuilder_component_uri = "s3://${module.package_s3_bucket.id}/${module.directory_for_amazon_ami_package.key}" //key (yaml file) must be less than 64 KB
  imagebuilder_component_version = "1.0.0"
  supported_os_versions = ["Amazon Linux 2023"]
  kms_key_id = module.kms.arn
  imagebuilder_component_uri = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = ["echo 'imagebuilder_component_amazon_linux'"]
        }
        name      = "imagebuilder_component"
        onFailure = "Continue"
      }]
    }]
    schemaVersion = 1.0
  })

  tags = {
    "Name" = "imagebuilder_component_for_amazon_linux"
  }
}

module "image_recipe_for_amazon_linux" {
  depends_on = [ module.imagebuilder_component_for_amazon_linux, module.kms ]

  source = "./module/aws_imagebuilder_image_recipe"
  imagebuilder_image_recipe_name = var.amazon_linux_imagebuilder_image_recipe_name
  imagebuilder_image_recipe_version = "1.0.0"
  imagebuilder_image_recipe_parent_image = "ami-0ebfd941bbafe70c6" //AMI ID is region specific
  imagebuilder_image_recipe_block_device_mapping_device_name = "/dev/xvdb" //  /dev/sda or /dev/xvdb.
  imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination = true
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_size = 10
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_type = "io1" // gp2 or io2.
  imagebuilder_image_recipe_block_device_mapping_ebs_iops = 100
  imagebuilder_image_recipe_component_arn = module.imagebuilder_component_for_amazon_linux.arn
  uninstall_systems_manager_agent_after_build = false
  user_data_base64 = base64encode(file("./scripts/amazon_linux_bootstrap.sh"))
  working_directory = "/home/ec2-user"
  kms_key_id = module.kms.arn
  imagebuilder_component_platform = "Linux"
  tags = {
    "Name" = "image_recipe_for_amazon"
  }
}


module "amazon_distribution" {
  depends_on = [ module.kms ]

  source = "./module/aws_imagebuilder_distribution_configuration"
  imagebuilder_distribution_configuration_name = "amazon-linux-ami-dis-conf"
  imagebuilder_distribution_configuration_description = "amazon-linux-ami-dis-conf-discription"
  imagebuilder_distribution_ami_tag = {image = "amazon-linux"}
  ami_distribution_name = "amazon-linux-ami-dist"
  # kms_key_id = module.kms.arn
  user_ids = local.account_id
  target_account_ids = local.account_id
  region = var.aws_region
  tags = {
      "Name" = "imagebuilder_amazon_linux_distribution"
  }
}

module "imagebuilder_amzon_linux_image_pipeline" {
  depends_on = [ module.image_recipe_for_amazon_linux, module.imagebuilder_infrastructure_configuration, module.amazon_distribution, module.image_builder_workflow, module.inspector2_enabler]

  source = "./module/aws_imagebuilder_image_pipeline"
  imagebuilder_image_pipeline_name = "amazon_linux_image_pipeline"
  imagebuilder_image_pipeline_description = "amazon_linux_image_pipeline"
  imagebuilder_image_pipeline_image_recipe_arn = module.image_recipe_for_amazon_linux.arn
  distribution_configuration_arn = module.amazon_distribution.arn
  execution_role_to_execute_workflow = module.aws_service_role_for_image_builder_role.arn //AWS managed role AWSServiceRoleForImageBuilder
  workflow_arn = module.image_builder_workflow.arn
  imagebuilder_image_pipeline_infrastructure_configuration_arn = module.imagebuilder_infrastructure_configuration.arn
  imagebuilder_image_pipeline_status = "ENABLED"
  imagebuilder_image_pipeline_schedule_expression = "cron(50 11 19 9 ? 2024)" //run every Friday at 8 AM. cron(0 8 ? * FRI *)
  magebuilder_image_pipeline_timezone = "UTC" //defaults to UTC //https://www.joda.org/joda-time/timezones.html
  imagebuilder_image_pipeline_pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY" //Possible values : EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE and EXPRESSION_MATCH_ONLY
  imagebuilder_image_pipeline_image_tests_enabled = true
  imagebuilder_image_pipeline_timeout_minutes = 60
  image_scanning_enabled = true
  tags = {
      "Name" = "imagebuilder_amazon_linux_image_pipeline"
  }
}

module "ssm_association_amazon_linux" {
  source = "./module/aws_ssm_association"

  ssm_association_document_name = "AWS-GatherSoftwareInventory"
  ssm_association_instance_key = "tag:Name"
  ssm_association_instance_id = ["Test instance for ${var.amazon_linux_imagebuilder_image_recipe_name}"]

  tags = {
      "Name" = "ssm_association_amazon_linux"
  }
}
