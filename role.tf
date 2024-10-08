/*Role that allow Inspector to scan EC2*/

module "ssm_role" {
  source = "./module/aws_iam_role"
  iam_role_name = var.ssm_role_name
  iam_role_trust_policy = file("./role_iam_policy_document.json")
}

module "ssm_policy_role_attachment" {
    depends_on = [ module.ssm_role ]

    source = "./module/aws_iam_role_policy_attachment"
    iam_role_name = module.ssm_role.name
    iam_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" //AWS managed policy
}

module "ssm_iam_instance_profile" {
  depends_on = [ module.ssm_role ]
  
  source = "./module/aws_iam_instance_profile"
  iam_instance_profile_name = var.ssm_iam_instance_profile_name
  iam_instance_profile_role = module.ssm_role.id
}

/*Image Builder ec2 infra configuration role*/

module "image_builder_infra_config_role" {
  source = "./module/aws_iam_role"
  iam_role_name = var.image_builder_infra_config_role_name
  iam_role_trust_policy = file("./role_iam_policy_document.json")
}

module "s3_read_only_policy" {
  source = "./module/aws_iam_policy"
  iam_policy_name = "s3_read_only_policy"
  iam_policy_description = "s3_read_only_policy"
  iam_policy_json_file_path = file("./s3_read_only_policy.json")
}

module "image_builder_infra_config_role_attachment" {
    depends_on = [ module.image_builder_infra_config_role ]

    source = "./module/aws_iam_role_policy_attachment"
    iam_role_name = module.image_builder_infra_config_role.name
    count      = "${length(var.image_builder_infra_config_iam_policy_arn)}"
    iam_policy_arn = var.image_builder_infra_config_iam_policy_arn[count.index] //AWS managed policy 
}

module "s3_read_only_policy_attachment" {
    depends_on = [ module.image_distribution_in_target_account_role ]

    source = "./module/aws_iam_role_policy_attachment"
    iam_role_name = module.image_builder_infra_config_role.name
    iam_policy_arn = module.s3_read_only_policy.arn
}

module "image_builder_infra_config_role_attachment_instance_profile" {
  depends_on = [ module.image_builder_infra_config_role ]

  source = "./module/aws_iam_instance_profile"
  iam_instance_profile_name = "image_builder_infra_config_instance_profile"
  iam_instance_profile_role = module.image_builder_infra_config_role.id
}


/*Image Builder workflow service role*/

module "aws_service_role_for_image_builder_role" {
  source = "./module/aws_iam_role"
  iam_role_name = "MyAWSServiceRoleForImageBuilder"
  iam_role_trust_policy = file("./imagebuilder_trust_policy.json")
}

module "iam_policy" {
  source = "./module/aws_iam_policy"
  iam_policy_name = "MyAWSServiceRoleForImageBuilderPolicy"
  iam_policy_description = "MyAWSServiceRoleForImageBuilderPolicy"
  iam_policy_json_file_path = file("./AWSServiceRoleForImageBuilderPolicy.json")
}

module "aws_service_role_for_image_builder_policyxx" {
    depends_on = [ module.aws_service_role_for_image_builder_role, module.iam_policy ]

    source = "./module/aws_iam_role_policy_attachment"
    iam_role_name = module.aws_service_role_for_image_builder_role.name
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

