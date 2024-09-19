variable "imagebuilder_image_recipe_name" {}
variable "imagebuilder_image_recipe_parent_image" {}
variable "imagebuilder_image_recipe_version" {}
variable "imagebuilder_image_recipe_component_arn" {}
# variable "imagebuilder_image_recipe_component_parameter_name" {}
# variable "imagebuilder_image_recipe_component_parameter_value" {}
variable "imagebuilder_image_recipe_block_device_mapping_device_name" {}
variable "imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination" {}
variable "imagebuilder_image_recipe_block_device_mapping_ebs_volume_size" {}
variable "imagebuilder_image_recipe_block_device_mapping_ebs_volume_type" {}
variable "imagebuilder_image_recipe_block_device_mapping_ebs_iops" {}
# variable "imagebuilder_image_recipe_block_device_mapping_ebs_throughput" {}
variable "uninstall_systems_manager_agent_after_build" {}
variable "user_data_base64" {}
variable "working_directory" {}