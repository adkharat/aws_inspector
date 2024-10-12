resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3bucket_id
  # topic {
  #   topic_arn = var.s3_event_notification_topic_arn
  #   events    = ["s3:ObjectCreated:*"] 
  # }

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events    = var.events
    filter_suffix = var.filter_suffix
  }
}