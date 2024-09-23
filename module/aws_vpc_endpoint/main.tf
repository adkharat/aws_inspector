resource "aws_vpc_endpoint" "vpc_gateway_endpoint" {
    vpc_id = var.vpc_endpoint_vpc_id
    service_name = var.vpc_endpoint_service_name
    vpc_endpoint_type = var.vpc_endpoint_type
    tags = var.vpc_endpoint_tags
}