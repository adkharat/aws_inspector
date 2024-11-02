module "image_builder_build_workflow" {
  source = "./module/aws_imagebuilder_workflow"

  workflow_name    = "Workflow to build an image"
  workflow_version = "1.0.0"
  workflow_type    = "BUILD" #BUILD, TEST
  # workflow_data_file_path = "s3://ec2inspackagebucket2/ubuntu/workflow.yaml"
  workflow_data_file_path = file("./buildworkflow.yaml") #buildworkflow.yaml
  kms_key_id              = module.kms_alias.kms_alias_arn
  tags = {
    "Name" = "aws_imagebuilder_build_workflow"
  }
}

module "image_builder_test_workflow" {
  source = "./module/aws_imagebuilder_workflow"

  workflow_name    = "Workflow to test an image"
  workflow_version = "1.0.0"
  workflow_type    = "TEST" #BUILD, TEST
  # workflow_data_file_path = "s3://ec2inspackagebucket2/ubuntu/workflow.yaml"
  workflow_data_file_path = file("./testworkflow.yaml") #buildworkflow.yaml
  kms_key_id              = module.kms_alias.kms_alias_arn
  tags = {
    "Name" = "aws_imagebuilder_test_workflow"
  }
}

module "imagebuilder_infrastructure_configuration" {
  # depends_on = [module.image_builder_infra_config_role_attachment_instance_profile, module.ssh_sg, module.http_sg, module.https_sg]
  depends_on = [module.image_builder_infra_config_role_attachment_instance_profile, module.https_sg] #module.https_sg

  source                                                                  = "./module/aws_imagebuilder_infrastructure_configuration"
  imagebuilder_infrastructure_configuration_name                          = "imagebuilder_ec2_infrastructure"
  imagebuilder_infrastructure_configuration_description                   = "imagebuilder_ec2_infrastructure"
  imagebuilder_infrastructure_configuration_subnet_id                     = module.private_subnet.id
  imagebuilder_infrastructure_configuration_instance_profile_name         = module.image_builder_infra_config_role_attachment_instance_profile.name
  imagebuilder_infrastructure_configuration_instance_types                = ["t2.micro"]
  imagebuilder_infrastructure_configuration_security_group_ids            = [module.https_sg.id]
  imagebuilder_infrastructure_configuration_terminate_instance_on_failure = true
  # imagebuilder_infrastructure_configuration_s3_logs = module.imagebuilder_ec2_infra_logs.id
  # imagebuilder_infrastructure_configuration_s3_key_prefix = "logs"
  tags = {
    "Name" = "imagebuilder_infrastructure_configuration"
  }
}