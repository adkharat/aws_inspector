//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_infrastructure_configuration
resource "aws_imagebuilder_infrastructure_configuration" "imagebuilder_infrastructure_configuration" {
    name = var.imagebuilder_infrastructure_configuration_name
    description = var.imagebuilder_infrastructure_configuration_description

    instance_profile_name = var.imagebuilder_infrastructure_configuration_instance_profile_name
    instance_types = var.imagebuilder_infrastructure_configuration_instance_types
    security_group_ids = var.imagebuilder_infrastructure_configuration_security_group_ids
    subnet_id = var.imagebuilder_infrastructure_configuration_subnet_id
    # sns_topic_arn = var.imagebuilder_infrastructure_configuration_sns_topic_arn
    # key_pair = var.imagebuilder_infrastructure_configuration_key_pair_name
    terminate_instance_on_failure = var.imagebuilder_infrastructure_configuration_terminate_instance_on_failure

    # logging {
    #   s3_logs {
    #     s3_bucket_name = var.imagebuilder_infrastructure_configuration_s3_logs
    #     s3_key_prefix = var.imagebuilder_infrastructure_configuration_s3_key_prefix
    #   }
    # }

    tags = var.tags
}