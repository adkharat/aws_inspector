module "ssh_sg" {
  source                             = "./module/aws_security_group"
  security_group_name                = var.ssh_sg_security_group_name
  security_group_description         = var.ssh_sg_security_group_description
  security_group_ingress_description = var.ssh_sg_security_group_ingress_description
  security_group_ingress_to_port     = var.ssh_sg_security_group_ingress_to_port
  security_group_ingress_from_port   = var.ssh_sg_security_group_ingress_from_port
}