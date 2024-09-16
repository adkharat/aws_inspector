//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_recipe
resource "aws_imagebuilder_image_recipe" "imagebuilder_image_recipe" {
    name = var.imagebuilder_image_recipe_name
    parent_image = var.imagebuilder_image_recipe_parent_image
    version = var.imagebuilder_image_recipe_version

    component {
      component_arn = var.imagebuilder_image_recipe_component_arn

      parameter {
        name = var.imagebuilder_image_recipe_component_parameter_name
        value = var.imagebuilder_image_recipe_component_parameter_value 
      }
    }

    block_device_mapping {
      device_name = var.imagebuilder_image_recipe_block_device_mapping_device_name
      
      ebs {
        delete_on_termination = var.imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination
        volume_size = var.imagebuilder_image_recipe_block_device_mapping_ebs_volume_size
        volume_type = var.imagebuilder_image_recipe_block_device_mapping_ebs_volume_type
      }
    }
}