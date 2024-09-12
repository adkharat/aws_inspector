resource "aws_instance" "ec2_instance" {
  ami           = var.aws_instance_ami_name
  instance_type = var.aws_instance_type
  # subnet_id = var.aws_instance_subnet_id TODO
  associate_public_ip_address = var.aws_instance_associate_public_ip_address
  vpc_security_group_ids      = var.aws_instance_vpc_security_group_ids

  root_block_device {
    volume_type           = var.aws_instance_volume_type
    volume_size           = var.aws_instance_volume_size
    iops = var.aws_instance_root_block_device_iops
    encrypted = var.aws_instance_root_block_device_encrypted
    kms_key_id = var.aws_instance_root_block_device_kms_key_id
    delete_on_termination = var.aws_instance_delete_on_termination
  }

  tags = {
    Name = var.aws_instance_ami_tag
  }
}