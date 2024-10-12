resource "aws_lambda_function" "lambda_function" {
    function_name = var.function_name
    filename = var.filename
    role = var.role
    runtime = var.runtime
    architectures = var.architectures
    timeout = var.timeout
    handler = var.handler
    # logging_config {
    #   log_format = var.log_format
    #   log_group = var.log_group
    # }
    tags = var.tags
}