resource "aws_inspector2_enabler" "inspector" {
  account_ids    = var.account_ids
  resource_types = var.resource_types
}