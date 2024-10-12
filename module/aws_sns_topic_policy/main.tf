resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn = var.sns_topic_arn
  policy = var.sns_policy
}