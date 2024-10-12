resource "aws_sns_topic_subscription" "topic_email_subscription" {
  count     = length(var.email_address)
  topic_arn = var.topic_arn
  protocol  = "email"
  endpoint  = var.email_address[count.index]
}