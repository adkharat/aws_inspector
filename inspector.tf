module "inspector2_enabler" {
  source         = "./module/aws_inspector2_enabler"
  account_ids    = local.account_id
  resource_types = var.resource_types
}
