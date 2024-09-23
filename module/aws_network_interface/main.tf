resource "aws_network_interface" "network_interface" {
    subnet_id = var.network_interface_subnet_id
    tags = var.network_interface_tags
}