module "imagebuilder_component_for_ubuntu" {
  depends_on = [ module.package_s3_bucket, module.directory_for_ubuntu_package ]
  
  source = "./module/aws_imagebuilder_component"
  imagebuilder_component_name = "imagebuilder_component_for_ubuntu"
  imagebuilder_component_platform = "Linux"
  imagebuilder_component_uri = "s3://${module.package_s3_bucket.id}/${module.directory_for_ubuntu_package.key}" //key (yaml file) must be less than 64 KB
  imagebuilder_component_version = "1.0.0"
}

module "image_recipe_for_ubuntu" {
  source = "./module/aws_imagebuilder_image_recipe"
  imagebuilder_image_recipe_name = "image_recipe_for_ubuntu"
  imagebuilder_image_recipe_version = "1.0.0"
  imagebuilder_image_recipe_parent_image = "ami-0e86e20dae9224db8"
  imagebuilder_image_recipe_block_device_mapping_device_name = "image_recipe_for_ubuntu_block_device_mapping"
  imagebuilder_image_recipe_block_device_mapping_ebs_delete_on_termination = true
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_size = 10
  imagebuilder_image_recipe_block_device_mapping_ebs_volume_type = "io1"
  imagebuilder_image_recipe_component_arn = module.imagebuilder_component_for_ubuntu.arn
}