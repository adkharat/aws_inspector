//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_component
resource "aws_imagebuilder_component" "imagebuilder_component" {
    name = var.imagebuilder_component_name
    platform = var.imagebuilder_component_platform
    uri = var.imagebuilder_component_uri
    version = var.imagebuilder_component_version
}