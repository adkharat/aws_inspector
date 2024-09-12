resource "aws_iam_policy" "iam_policy" {
    name = var.iam_policy_name
    description = var.iam_policy_description
    policy = file(var.iam_policy_json_file_path)
}