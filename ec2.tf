module "amazon_ami_ec2" {
  source                             = "./module/ec2"
  aws_instance_type                  = var.amazon_ami_ec2_instance_type
  aws_instance_ami_name              = var.amazon_ami_ec2_ami_name
  aws_instance_ami_tag               = var.amazon_ami_ec2_tag
  aws_instance_volume_size           = var.amazon_ami_ec2_volume_size
  aws_instance_volume_type           = var.amazon_ami_ec2_volume_type
  aws_instance_delete_on_termination = var.amazon_ami_ec2_delete_on_termination
}