provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.13"
}

data "aws_caller_identity" "current" {}
data "aws_iam_users" "iam_users" {}
data "aws_availability_zones" "available" {}

locals {
  account_id = [data.aws_caller_identity.current.account_id]
  current_user_id = data.aws_caller_identity.current.user_id
  current_id = data.aws_caller_identity.current.id
  current_arn = data.aws_caller_identity.current.arn
  iam_users = data.aws_iam_users.iam_users.names
}
