//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_pipeline
resource "aws_imagebuilder_image_pipeline" "imagebuilder_image_pipeline" {
    name = var.imagebuilder_image_pipeline_name
    description = var.imagebuilder_image_pipeline_description
    status = var.imagebuilder_image_pipeline_status

    image_recipe_arn = var.imagebuilder_image_pipeline_image_recipe_arn
    infrastructure_configuration_arn = var.imagebuilder_image_pipeline_infrastructure_configuration_arn
    distribution_configuration_arn = var.distribution_configuration_arn
    
    schedule {
      schedule_expression = var.imagebuilder_image_pipeline_schedule_expression //https://docs.aws.amazon.com/imagebuilder/latest/userguide/cron-expressions.html
      pipeline_execution_start_condition = var.imagebuilder_image_pipeline_pipeline_execution_start_condition
      timezone = var.magebuilder_image_pipeline_timezone //https://www.joda.org/joda-time/timezones.html
    }

    execution_role = var.execution_role_to_execute_workflow //AWS managed role/policy AWSServiceRoleForImageBuilder

    workflow {
      workflow_arn = var.workflow_arn
      parameter {
        name = "waitForActionAtEnd"
        value = false
      }
    }

    image_scanning_configuration {
      image_scanning_enabled = var.image_scanning_enabled
    }
    
    # Test the image after build
    image_tests_configuration {
      image_tests_enabled = var.imagebuilder_image_pipeline_image_tests_enabled
      timeout_minutes = var.imagebuilder_image_pipeline_timeout_minutes
    }
}