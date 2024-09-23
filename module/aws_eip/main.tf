resource "aws_eip" "eip" {
    domain = var.eip_domain
}