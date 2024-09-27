//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_recipe
resource "aws_imagebuilder_image_recipe" "imagebuilder_image_recipe" {
    name = var.imagebuilder_image_recipe_name
    parent_image = var.imagebuilder_image_recipe_parent_image
    version = var.imagebuilder_image_recipe_version
    working_directory = var.working_directory
    

    component {
      component_arn = var.imagebuilder_image_recipe_component_arn

      # parameter {
      #   name = var.imagebuilder_image_recipe_component_parameter_name
      #   value = var.imagebuilder_image_recipe_component_parameter_value 
      # }
    }

    block_device_mapping {
      device_name = var.imagebuilder_image_recipe_block_device_mapping_device_name // /dev/sda or /dev/xvdb.
      
      ebs {
        delete_on_termination = var.imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination
        volume_size = var.imagebuilder_image_recipe_block_device_mapping_ebs_volume_size
        volume_type = var.imagebuilder_image_recipe_block_device_mapping_ebs_volume_type //gp2 or io2.
        iops = var.imagebuilder_image_recipe_block_device_mapping_ebs_iops
        kms_key_id = var.kms_key_id
        # throughput = var.imagebuilder_image_recipe_block_device_mapping_ebs_throughput // For GP3 volumes only
        # encrypted             = true
        # kms_key_id            = "alias/aws/ebs"
      }
    }

    //script to run when you launch your build instance
    user_data_base64 = var.user_data_base64

    //SSM agent installed by default by Image Builder
    systems_manager_agent {
      uninstall_after_build = var.uninstall_systems_manager_agent_after_build
    }

    tags = var.tags
}