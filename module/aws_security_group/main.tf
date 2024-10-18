resource "aws_security_group" "security_group" {

  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.security_group_vpc_id //TODO : To Enable

  ingress {
    description = var.security_group_ingress_description
    from_port   = var.security_group_ingress_from_port
    to_port     = var.security_group_ingress_to_port
    protocol    = "tcp"
    cidr_blocks = (
      var.security_group_ingress_from_port >= 443 && var.security_group_ingress_to_port <= 445 ||
      var.security_group_ingress_from_port >= 1020 && var.security_group_ingress_to_port <= 1025
    ) ? ["0.0.0.0/0"] : [] # Empty list if the port is not authorized for 0.0.0.0/0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}