module "imagebuilder_component_for_ubuntu" {
  depends_on = [module.package_s3_bucket, module.component_for_ubuntu_package, module.kms]

  source                          = "./module/aws_imagebuilder_component"
  imagebuilder_component_name     = "imagebuilder_component_for_ubuntu"
  imagebuilder_component_platform = "Linux"
  imagebuilder_component_uri      = "s3://${module.package_s3_bucket.id}/${module.component_for_ubuntu_package.key}" //key (yaml file) must be less than 64 KB
  imagebuilder_component_version  = "1.0.0"
  supported_os_versions           = ["Ubuntu 22.04"]
  kms_key_id                      = module.kms_alias.kms_alias_arn
  # imagebuilder_component_uri = yamlencode({
  #   phases = [{
  #     name = "build"
  #     steps = [{
  #       action = "ExecuteBash"
  #       inputs = {
  #         commands = ["echo 'imagebuilder_component ubuntu'"]
  #       }
  #       name      = "imagebuilder_component"
  #       onFailure = "Continue"
  #     }]
  #   }]
  #   schemaVersion = 1.0
  # })

  tags = {
    "Name" = "imagebuilder_component_for_ubuntu"
  }
}

module "image_recipe_for_ubuntu" {
  depends_on = [module.imagebuilder_component_for_ubuntu, module.kms]

  source                                                                   = "./module/aws_imagebuilder_image_recipe"
  imagebuilder_image_recipe_name                                           = var.ubuntu_imagebuilder_image_recipe_name
  imagebuilder_image_recipe_version                                        = "1.0.0"
  imagebuilder_image_recipe_parent_image                                   = "ami-0a0e5d9c7acc336f1"
  imagebuilder_image_recipe_block_device_mapping_device_name               = "/dev/sda1" //  /dev/sda or /dev/xvdb.
  imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination = true
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_size           = 10
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_type           = "io1" // gp2 or io2.
  imagebuilder_image_recipe_block_device_mapping_ebs_iops                  = 100
  imagebuilder_image_recipe_component_arn                                  = module.imagebuilder_component_for_ubuntu.arn
  uninstall_systems_manager_agent_after_build                              = false
  user_data_base64                                                         = base64encode(file("./scripts/ubuntu_bootstrap.sh"))
  working_directory                                                        = "/tmp"
  encrypted                                                                = true
  imagebuilder_component_platform                                          = "Linux"
  kms_key_id                                                               = module.kms_alias.kms_alias_name
  tags = {
    "Name" = "image_recipe_for_ubuntu"
  }
}

module "ubuntu_distribution" {
  depends_on = [module.kms]

  source                                              = "./module/aws_imagebuilder_distribution_configuration"
  imagebuilder_distribution_configuration_name        = "ubuntu-ami-dis-conf"
  imagebuilder_distribution_configuration_description = "ubuntu-ami-dis-conf-discription"
  imagebuilder_distribution_ami_tag                   = { image = "ubuntu" , Name = "ecp-golden-ami-ubuntu" }
  ami_distribution_name                               = "ubuntu-ami-dist"
  kms_key_id                                          = module.kms_alias.kms_alias_arn
  user_ids                                            = ["211125510693", "602304653960"]
  target_account_ids                                  = ["211125510693", "602304653960"]
  # user_ids = ["602304653960"]
  # target_account_ids = [ "602304653960"]

  region = "us-east-1"
  tags = {
    "Name" = "imagebuilder_ubuntu_distribution"
  }
}

# module "imagebuilder_ubuntu_image" {
#   depends_on = [ module.ubuntu_distribution, module.image_recipe_for_ubuntu, module.imagebuilder_infrastructure_configuration ]

#   source = "./module/aws_imagebuilder_image"
#   imagebuilder_image_distribution_configuration_arn = module.ubuntu_distribution.arn
#   imagebuilder_image_image_recipe_arn = module.image_recipe_for_ubuntu.arn
#   imagebuilder_image_infrastructure_configuration_arn = module.imagebuilder_infrastructure_configuration.arn
# }

//run every Friday morning at 8 am UTC. Enabled testing of the image and setting a timeout of 60 minutes.
module "imagebuilder_ubuntu_image_pipeline" {
  depends_on = [module.image_recipe_for_ubuntu, module.imagebuilder_infrastructure_configuration, module.ubuntu_distribution, module.image_builder_build_workflow, module.image_builder_test_workflow, module.inspector2_enabler]

  source                                                         = "./module/aws_imagebuilder_image_pipeline"
  imagebuilder_image_pipeline_name                               = "ubuntu_image_pipeline"
  imagebuilder_image_pipeline_description                        = "ubuntu_image_pipeline"
  imagebuilder_image_pipeline_image_recipe_arn                   = module.image_recipe_for_ubuntu.arn
  distribution_configuration_arn                                 = module.ubuntu_distribution.arn
  execution_role_to_execute_workflow                             = module.aws_service_role_for_image_builder_role.arn //AWS managed role AWSServiceRoleForImageBuilder
  build_workflow_arn                                             = module.image_builder_build_workflow.arn            #Build workflow
  test_workflow_arn                                              = module.image_builder_test_workflow.arn             #Test workflow
  imagebuilder_image_pipeline_infrastructure_configuration_arn   = module.imagebuilder_infrastructure_configuration.arn
  imagebuilder_image_pipeline_status                             = "ENABLED"
  imagebuilder_image_pipeline_schedule_expression                = "cron(0 10 * * ? *)"    //Run daily at 10:00 AM
  magebuilder_image_pipeline_timezone                            = "UTC"                   //defaults to UTC //https://www.joda.org/joda-time/timezones.html
  imagebuilder_image_pipeline_pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY" //Possible values : EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE and EXPRESSION_MATCH_ONLY
  imagebuilder_image_pipeline_image_tests_enabled                = true
  imagebuilder_image_pipeline_timeout_minutes                    = 60
  image_scanning_enabled                                         = true
  tags = {
    "Name" = "imagebuilder_ubuntu_image_pipeline"
  }
}

module "ssm_association_ubuntu" {
  source = "./module/aws_ssm_association"

  ssm_association_document_name = "AWS-GatherSoftwareInventory"
  ssm_association_instance_key  = "tag:Name"
  ssm_association_instance_id   = ["Test instance for ${var.ubuntu_imagebuilder_image_recipe_name}"]

  tags = {
    "Name" = "ssm_association_ubuntu"
  }
}


