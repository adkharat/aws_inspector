variable "aws_region" {}
variable "resource_types" {}

variable "amazon_ami_ec2_ami_name" {}
variable "amazon_ami_ec2_instance_type" {}
variable "amazon_ami_ec2_tag" {}
variable "amazon_ami_ec2_volume_type" {}
variable "amazon_ami_ec2_volume_size" {}
variable "amazon_ami_ec2_delete_on_termination" {}
variable "amazon_ami_ec2_associate_public_ip_address" {}
variable "ssh_sg_security_group_name" {}
variable "ssh_sg_security_group_description" {}
variable "ssh_sg_security_group_ingress_description" {}
variable "ssh_sg_security_group_ingress_to_port" {}
variable "ssh_sg_security_group_ingress_from_port" {}