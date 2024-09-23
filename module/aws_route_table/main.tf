resource "aws_route_table" "route_table" {
    vpc_id = var.route_table_vpc_id
  #   route {
  #   cidr_block     = var.route_table_route[0].cidr_block
  #   nat_gateway_id = var.route_table_route[0].nat_gateway_id
  # }
  tags = var.tags
}