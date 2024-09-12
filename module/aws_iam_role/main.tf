resource "aws_iam_role" "iam_role" {
    name = var.iam_role_name
    assume_role_policy = var.iam_role_trust_policy
}