//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_distribution_configuration
resource "aws_imagebuilder_distribution_configuration" "imagebuilder_distribution_configuration" {
    name = var.imagebuilder_distribution_configuration_name
    distribution {
      ami_distribution_configuration {
        ami_tags = var.imagebuilder_distribution_ami_tag
        name = "${var.ami_distribution_name}-{{ imagebuilder:buildDate }}"
        launch_permission {
          user_ids = var.user_ids
        }
        kms_key_id = var.kms_key_id
      }

      region = var.region
    }
}