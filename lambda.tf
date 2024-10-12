module "lambda_function" {
  source = "./module/aws_lambda_function"
  filename = "lambda_function.zip"
  function_name = var.lambda_function_name 
  runtime = "python3.12"
  architectures = ["x86_64"]
  role = module.ses_full_access_role.arn
  timeout = 10
  handler = "lambda_function.lambda_handler"
  tags = {
     "Name" = "ecp_golden_image"
  }
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

module "s3_bucket_notification" {
  depends_on = [ module.inspectorscaningfile, module.lambda_function ]
  source = "./module/aws_s3_bucket_notification"
  s3bucket_id = module.inspectorscaningfile.id
  events = ["s3:ObjectCreated:*"] 
  filter_suffix = ".csv"
  lambda_function_arn = module.lambda_function.arn
}

module "ses" {
  source = "./module/aws_ses_email_identity"
  ses_email = var.email_address
}
