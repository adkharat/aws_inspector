# provider "aws" {
#   alias  = "secondary"
#   region = "us-east-2"
# }

# resource "aws_kms_replica_key" "replica" {
#   provider = aws.secondary
#   description             = "Multi-Region replica key"
#   deletion_window_in_days = 7
#   primary_key_arn         = var.primary_key_arn
# }