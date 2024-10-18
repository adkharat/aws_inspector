locals {
  inspector_status = "disabled" # "command to check if enabled" # Placeholder, replace with actual command output
}

module "inspector2_enabler" {
  source         = "./module/aws_inspector2_enabler"
  account_ids    = local.account_id
  resource_types = var.resource_types
  count          = local.inspector_status == "disabled" ? 1 : 0
}
