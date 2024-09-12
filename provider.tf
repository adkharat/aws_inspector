provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.13"
}

data "aws_caller_identity" "current" {}

locals {
    account_id = [data.aws_caller_identity.current.account_id]
}
