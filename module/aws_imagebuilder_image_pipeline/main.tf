//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_pipeline
resource "aws_imagebuilder_image_pipeline" "imagebuilder_image_pipeline" {
    name = var.imagebuilder_image_pipeline_name
    image_recipe_arn = var.imagebuilder_image_pipeline_image_recipe_arn
    infrastructure_configuration_arn = var.imagebuilder_image_pipeline_infrastructure_configuration_arn
    status = var.imagebuilder_image_pipeline_status
    description = var.imagebuilder_image_pipeline_description
    
    schedule {
      schedule_expression = var.imagebuilder_image_pipeline_schedule_expression
      pipeline_execution_start_condition = var.imagebuilder_image_pipeline_pipeline_execution_start_condition
    }

    image_tests_configuration {
      image_tests_enabled = var.imagebuilder_image_pipeline_image_tests_enabled
      timeout_minutes = var.imagebuilder_image_pipeline_timeout_minutes
    }
}