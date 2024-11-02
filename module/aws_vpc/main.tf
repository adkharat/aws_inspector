resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.vpc_instance_tenancy
    enable_dns_support = var.vpc_enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = var.vpc_tag
}