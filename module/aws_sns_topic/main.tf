resource "aws_sns_topic" "sns_topic" {
  name = var.sns_topic_name
  fifo_topic = var.is_fifo_topic
  delivery_policy = var.delivery_policy
  policy = var.policy
  tags = var.tags
}