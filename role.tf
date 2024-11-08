/*Role that allow Inspector to scan EC2*/

# module "ssm_role" {
#   source                = "./module/aws_iam_role"
#   iam_role_name         = var.ssm_role_name
#   iam_role_trust_policy = file("./role_iam_policy_document.json")
# }

# module "ssm_policy_role_attachment" {
#   depends_on = [module.ssm_role]

#   source         = "./module/aws_iam_role_policy_attachment"
#   iam_role_name  = module.ssm_role.name
#   iam_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" //AWS managed policy
# }

# module "ssm_iam_instance_profile" {
#   depends_on = [module.ssm_role]

#   source                    = "./module/aws_iam_instance_profile"
#   iam_instance_profile_name = var.ssm_iam_instance_profile_name
#   iam_instance_profile_role = module.ssm_role.id
# }

/*Image Builder ec2 infra configuration role*/

module "image_builder_infra_config_role" {
  source                = "./module/aws_iam_role"
  iam_role_name         = var.image_builder_infra_config_role_name
  iam_role_trust_policy = file("./role_iam_policy_document.json")
}

module "s3_read_only_policy" {
  source                    = "./module/aws_iam_policy"
  iam_policy_name           = "s3_read_only_policy"
  iam_policy_description    = "s3_read_only_policy"
  iam_policy_json_file_path = file("./s3_read_only_policy.json")
}

module "ec2_decrypt_s3_data_policy" {
  source                    = "./module/aws_iam_policy"
  iam_policy_name           = "ec2_decrypt_s3_data"
  iam_policy_description    = "ec2_decrypt_s3_data"
  iam_policy_json_file_path = data.aws_iam_policy_document.ec2_s3_data_decrypt_policy.json
}

module "image_builder_infra_config_role_attachment" {
  depends_on = [module.image_builder_infra_config_role]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.image_builder_infra_config_role.name
  count          = length(var.image_builder_infra_config_iam_policy_arn)
  iam_policy_arn = var.image_builder_infra_config_iam_policy_arn[count.index] //AWS managed policy 
}

module "s3_read_only_policy_attachment" {
  depends_on = [module.image_builder_infra_config_role]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.image_builder_infra_config_role.name
  iam_policy_arn = module.s3_read_only_policy.arn
}

module "s3_decrypt_data_policy_attachment" {
  depends_on = [module.image_builder_infra_config_role]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.image_builder_infra_config_role.name
  iam_policy_arn = module.ec2_decrypt_s3_data_policy.arn
}

module "image_builder_infra_config_role_attachment_instance_profile" {
  depends_on = [module.image_builder_infra_config_role]

  source                    = "./module/aws_iam_instance_profile"
  iam_instance_profile_name = "image_builder_infra_config_instance_profile"
  iam_instance_profile_role = module.image_builder_infra_config_role.id
}


/*PIPELINE---Image Builder workflow service role*/

module "aws_service_role_for_image_builder_role" {
  source                = "./module/aws_iam_role"
  iam_role_name         = "MyAWSServiceRoleForImageBuilder"
  iam_role_trust_policy = file("./imagebuilder_trust_policy.json")
}

module "iam_policy" {
  source                    = "./module/aws_iam_policy"
  iam_policy_name           = "MyAWSServiceRoleForImageBuilderPolicy"
  iam_policy_description    = "MyAWSServiceRoleForImageBuilderPolicy"
  iam_policy_json_file_path = file("./AWSServiceRoleForImageBuilderPolicy.json")
}

module "image_builder_cross_account_distribution_access_policy_attachment" {
  depends_on = [module.aws_service_role_for_image_builder_role]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.aws_service_role_for_image_builder_role.name
  iam_policy_arn = "arn:aws:iam::aws:policy/Ec2ImageBuilderCrossAccountDistributionAccess" //AWS managed policy
}

module "aws_service_role_for_image_builder_policy" {
  depends_on = [module.aws_service_role_for_image_builder_role, module.iam_policy]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.aws_service_role_for_image_builder_role.name
  iam_policy_arn = module.iam_policy.arn
}

/*Golden Image Distribution Role for Target Account*/

module "image_distribution_in_target_account_role" {
  source = "./module/aws_iam_role"
  iam_role_name = "EC2ImageBuilderDistributionCrossAccountRole"
  iam_role_trust_policy = file("./allow_image_sharing_trust_policy.json") //Replace SOURCE ACCOUNT in Trust policy
}

module "cross_account_distribution_policy_attachment" {
    depends_on = [ module.image_distribution_in_target_account_role ]

    source = "./module/aws_iam_role_policy_attachment"
    iam_role_name = module.image_distribution_in_target_account_role.name
    iam_policy_arn = "arn:aws:iam::aws:policy/Ec2ImageBuilderCrossAccountDistributionAccess" //AWS managed policy
}

module "cross_account_kms_iam_policy" {
  source = "./module/aws_iam_policy"
  iam_policy_name = "cross_account_kms_iam_policy"
  iam_policy_description = "cross_account_kms_iam_policy"
  iam_policy_json_file_path = file("./cross_account_kms_iam_policy.json")
}

module "cross_account_kms_iam_policy_attachment" {
    depends_on = [ module.image_distribution_in_target_account_role ]

    source = "./module/aws_iam_role_policy_attachment"
    iam_role_name = module.image_distribution_in_target_account_role.name
    iam_policy_arn = module.cross_account_kms_iam_policy.arn
}

/* ses related role */
module "ses_full_access_role" {
  source                = "./module/aws_iam_role"
  iam_role_name         = "sesFullAccessRole"
  iam_role_trust_policy = file("./ses_role_trust_entity.json")
}

module "lambda_logging_policy" {
  source                    = "./module/aws_iam_policy"
  iam_policy_name           = "lambda_logs"
  iam_policy_description    = "IAM policy for logging from a lambda"
  iam_policy_json_file_path = file("./lambda_logging.json")
}

module "ses_full_access_role_policy_attachment" {
  depends_on = [module.ses_full_access_role]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.ses_full_access_role.name
  iam_policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess" //AWS managed policy
}

module "ses_lambda_logging_policy_attachment" {

  depends_on = [module.ses_full_access_role, module.lambda_logging_policy]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.ses_full_access_role.name
  iam_policy_arn = module.lambda_logging_policy.arn
}

//VPC Flow Logs role and Policy
module "golden_vpc_flow_log_role" {
  source                = "./module/aws_iam_role"
  iam_role_name         = "golden_vpc_flow_log_role"
  iam_role_trust_policy = file("./vpc_flow_logs.json")
}

module "logs_policy" {
  source                    = "./module/aws_iam_policy"
  iam_policy_name           = "flow_logs_policy"
  iam_policy_description    = "flow_logs_policy"
  iam_policy_json_file_path = file("./flow_logs.json")
}

module "logs_policy_and_role_attachment" {

  depends_on = [module.golden_vpc_flow_log_role, module.logs_policy]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.golden_vpc_flow_log_role.name
  iam_policy_arn = module.logs_policy.arn
}

/* execution_role_for_lifecycle_policy */
module "execution_role_for_ami_lifecycle" {
  source                = "./module/aws_iam_role"
  iam_role_name         = "execution_role_for_lifecycle_policy"
  iam_role_trust_policy = data.aws_iam_policy_document.execution_role_for_lifecycle_policy_assume_role.json
}

module "lifecycle_policy_role_attachment" {

  depends_on = [module.execution_role_for_ami_lifecycle]

  source         = "./module/aws_iam_role_policy_attachment"
  iam_role_name  = module.execution_role_for_ami_lifecycle.name
  iam_policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/EC2ImageBuilderLifecycleExecutionPolicy"
}