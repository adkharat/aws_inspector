module "imagebuilder_component_for_ubuntu" {
  depends_on = [ module.package_s3_bucket, module.directory_for_ubuntu_package ]
  
  source = "./module/aws_imagebuilder_component"
  imagebuilder_component_name = "imagebuilder_component_for_ubuntu"
  imagebuilder_component_platform = "Linux"
  # imagebuilder_component_uri = "s3://${module.package_s3_bucket.id}/${module.directory_for_ubuntu_package.key}" //key (yaml file) must be less than 64 KB
  imagebuilder_component_version = "1.0.0"
  supported_os_versions = ["Ubuntu 22.04"]
  imagebuilder_component_uri = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = ["echo 'hello world'"]
        }
        name      = "example"
        onFailure = "Continue"
      }]
    }]
    schemaVersion = 1.0
  })
}

module "image_recipe_for_ubuntu" {
  depends_on = [ module.imagebuilder_component_for_ubuntu ]

  source = "./module/aws_imagebuilder_image_recipe"
  imagebuilder_image_recipe_name = var.ubuntu_imagebuilder_image_recipe_name
  imagebuilder_image_recipe_version = "1.0.0"
  imagebuilder_image_recipe_parent_image = "ami-0a0e5d9c7acc336f1"
  imagebuilder_image_recipe_block_device_mapping_device_name = "/dev/xvdb" //  /dev/sda or /dev/xvdb.
  imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination = true
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_size = 10
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_type = "io1" // gp2 or io2.
  imagebuilder_image_recipe_block_device_mapping_ebs_iops = 100
  imagebuilder_image_recipe_component_arn = module.imagebuilder_component_for_ubuntu.arn
  uninstall_systems_manager_agent_after_build = false
  user_data_base64 = base64encode(file("./scripts/ubuntu_bootstrap.sh"))
  working_directory = "/tmp"
}

module "imagebuilder_infrastructure_configuration" {
    depends_on = [ module.image_builder_infra_config_role_attachment_instance_profile, module.ssh_sg, module.http_sg, module.https_sg ]

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

# module "imagebuilder_ubuntu_image" {
#   depends_on = [ module.ubuntu_distribution, module.image_recipe_for_ubuntu, module.imagebuilder_infrastructure_configuration ]
  
#   source = "./module/aws_imagebuilder_image"
#   imagebuilder_image_distribution_configuration_arn = module.ubuntu_distribution.arn
#   imagebuilder_image_image_recipe_arn = module.image_recipe_for_ubuntu.arn
#   imagebuilder_image_infrastructure_configuration_arn = module.imagebuilder_infrastructure_configuration.arn
# }

module "image_builder_workflow" {
  source = "./module/aws_imagebuilder_workflow"

  workflow_name = "Workflow to test an image"
  workflow_version = "1.0.0"
  workflow_type = "TEST"
  # workflow_data_file_path = "s3://ec2inspackagebucket2/ubuntu/workflow.yaml"
  workflow_data_file_path = file("./workflow.yaml")
}

//run every Friday morning at 8 am UTC. Enabled testing of the image and setting a timeout of 60 minutes.
module "imagebuilder_ubuntu_image_pipeline" {
  depends_on = [ module.image_recipe_for_ubuntu, module.imagebuilder_infrastructure_configuration, module.ubuntu_distribution, module.image_builder_workflow, module.inspector2_enabler]

  source = "./module/aws_imagebuilder_image_pipeline"
  imagebuilder_image_pipeline_name = "ubuntu_image_pipeline"
  imagebuilder_image_pipeline_description = "ubuntu_image_pipeline"
  imagebuilder_image_pipeline_image_recipe_arn = module.image_recipe_for_ubuntu.arn
  distribution_configuration_arn = module.ubuntu_distribution.arn
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
}

module "ssm_association_ubuntu" {
  source = "./module/aws_ssm_association"

  ssm_association_document_name = "AWS-GatherSoftwareInventory"
  ssm_association_instance_key = "tag:Name"
  ssm_association_instance_id = ["Test instance for ${var.ubuntu_imagebuilder_image_recipe_name}"]
}


