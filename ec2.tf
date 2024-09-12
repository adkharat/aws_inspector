module "amazon_linux_2023_ami_ec2" {
  depends_on = [module.ssh_sg]

  source                                    = "./module/aws_ec2"
  aws_instance_type                         = var.amazon_ami_ec2_instance_type
  aws_instance_ami_name                     = var.amazon_ami_ec2_ami_name
  aws_instance_ami_tag                      = var.amazon_ami_ec2_tag
  aws_instance_volume_size                  = var.amazon_ami_ec2_volume_size
  aws_instance_volume_type                  = var.amazon_ami_ec2_volume_type
  aws_instance_root_block_device_iops       = var.amazon_ami_ec2_root_block_device_iops
  aws_instance_root_block_device_encrypted  = var.amazon_ami_ec2_root_block_device_encrypted
  aws_instance_root_block_device_kms_key_id = module.ebs_kms.arn
  aws_instance_delete_on_termination        = var.amazon_ami_ec2_delete_on_termination
  aws_instance_associate_public_ip_address  = var.amazon_ami_ec2_associate_public_ip_address
  aws_instance_vpc_security_group_ids       = [module.ssh_sg.id, module.http_sg.id, module.https_sg.id]
}

module "ubuntu_server_ec2" {
  depends_on = [module.ssh_sg]

  source                                    = "./module/aws_ec2"
  aws_instance_type                         = var.ubuntu_server_ec2_instance_type
  aws_instance_ami_name                     = var.ubuntu_server_ec2_ami_name
  aws_instance_ami_tag                      = var.ubuntu_server_ec2_tag
  aws_instance_volume_size                  = var.ubuntu_server_ec2_volume_size
  aws_instance_volume_type                  = var.ubuntu_server_ec2_volume_type
  aws_instance_root_block_device_iops       = var.ubuntu_server_ec2_root_block_device_iops
  aws_instance_root_block_device_encrypted  = var.ubuntu_server_ec2_root_block_device_encrypted
  aws_instance_root_block_device_kms_key_id = module.ebs_kms.arn
  aws_instance_delete_on_termination        = var.ubuntu_server_ec2_delete_on_termination
  aws_instance_associate_public_ip_address  = var.ubuntu_server_ec2_associate_public_ip_address
  aws_instance_vpc_security_group_ids       = [module.ssh_sg.id, module.http_sg.id, module.https_sg.id]
}


