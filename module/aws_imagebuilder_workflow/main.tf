//https://docs.aws.amazon.com/imagebuilder/latest/userguide/security-iam-awsmanpol.html#sec-iam-manpol-AWSServiceRoleForImageBuilder
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_workflow
resource "aws_imagebuilder_workflow" "imagebuilder_workflow" {
    name = var.workflow_name
    version = var.workflow_version
    type = var.workflow_type
    data = var.workflow_data_file_path
    # uri = var.workflow_data_file_path
    kms_key_id = var.kms_key_id
    tags = var.tags
}