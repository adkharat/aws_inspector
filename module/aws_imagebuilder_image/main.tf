//https://registry.terraform.io/providers/hashicorp/aws/3.76.1/docs/resources/imagebuilder_image
resource "aws_imagebuilder_image" "imagebuilder_image" {
  distribution_configuration_arn     = var.imagebuilder_image_distribution_configuration_arn
  image_recipe_arn                   = var.imagebuilder_image_image_recipe_arn
  infrastructure_configuration_arn   = var.imagebuilder_image_infrastructure_configuration_arn
}