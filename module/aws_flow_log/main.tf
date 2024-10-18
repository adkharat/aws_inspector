resource "aws_flow_log" "golden_vpc_flow_log" {
  log_destination      = var.log_destination_arn
  iam_role_arn         = var.iam_role_arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  tags = var.tags
}