//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association
resource "aws_ssm_association" "ssm_association" {
  name = var.ssm_association_document_name
  parameters = {
    applications                = "Enabled"
    awsComponents               = "Enabled"
    customInventory             = "Enabled"
    instanceDetailedInformation = "Enabled"
    networkConfig               = "Enabled"
    services                    = "Enabled"
    windowsRoles                = "Enabled"
    windowsUpdates              = "Enabled"
  }
  
  schedule_expression = "rate(30 minutes)"

  targets {
    key    = var.ssm_association_instance_key
    values = var.ssm_association_instance_id
  }

  tags = var.tags
}