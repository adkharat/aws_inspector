module "vpc" {
  source = "./module/aws_vpc"

  vpc_cidr_block = "10.0.0.0/16"

  vpc_instance_tenancy = "default"
  vpc_enable_dns_support = true
  vpc_tag = {
    "Name" = "golden_image_vpc"
  }
}

module "private_subnet" {
  depends_on = [ module.vpc ]

  source = "./module/aws_subnet"

  subnet_vpc_id = module.vpc.id
  subnet_cidr_block = "10.0.1.0/24"
  subnet_availability_zone = data.aws_availability_zones.available.names[0]
  subnet_map_public_ip_on_launch = false
  subnet_tags = {
    "Name" = "golden_image_private_subnet"
  }
}

module "public_subnet" {
  depends_on = [ module.vpc ]

  source = "./module/aws_subnet"

  subnet_vpc_id = module.vpc.id
  subnet_cidr_block = "10.0.2.0/24"
  subnet_availability_zone = data.aws_availability_zones.available.names[0]
  subnet_map_public_ip_on_launch = true
  subnet_tags = {
    "Name" = "golden_image_public_subnet"
  }
}

module "igw" {
  depends_on = [ module.vpc ]

  source = "./module/aws_internet_gateway"

  vpc_id = module.vpc.id
  tags = {
    "Name" = "golden_image_vpc_igw"
  }
}

module "elastic_ip" {
  source = "./module/aws_eip"

  eip_domain = "vpc"
}

module "nat_gateway" {
  depends_on = [  module.vpc, module.elastic_ip, module.public_subnet ]

  source = "./module/aws_nat_gateway"

  allocation_id = module.elastic_ip.id
  subnet_id = module.public_subnet.id
  tags = {
    "Name" = "golden_image_nat_gateway"
  }
}

# module "private_subnet_network_interface" {
#   depends_on = [ module.private_subnet ]

#   source = "./module/aws_network_interface"
#   network_interface_subnet_id = module.private_subnet.id
#   network_interface_tags = {
#     "Name" = "golden_image_network_interface"
#   }
# }

module "private_subnet_route_table" {
  depends_on = [ module.vpc, module.nat_gateway ]

  source = "./module/aws_route_table"
  route_table_vpc_id = module.vpc.id
  # route_table_route = [{
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = module.nat_gateway.id
  # }]
  
  tags = {
    "Name" = "golden_image_private_subnet_route_table"
  }
}

# module "public_subnet_route_table" {
#   depends_on = [ module.vpc, module.igw ]

#   source = "./module/aws_route_table"
#   route_table_vpc_id = module.vpc.id

#   # route_table_route = [{
#   #   cidr_block = "0.0.0.0/0"
#   #   igw = module.igw.id
#   # }]

#   tags = {
#     "Name" = "golden_image_public_subnet_route_table"
#   }
# }

module "private_route_table_association" {
  source = "./module/aws_route_table_association"
  route_table_id = module.private_subnet_route_table.id
  subnet_id = module.private_subnet.id
}

# module "public_route_table_association" {
#   source = "./module/aws_route_table_association"
#   route_table_id = module.public_subnet_route_table.id
#   subnet_id = module.public_subnet.id
# }

module "vpc_endpoint" {
  depends_on = [ module.vpc, module.private_subnet ]

  source = "./module/aws_vpc_endpoint"

  vpc_endpoint_vpc_id = module.vpc.id
  vpc_endpoint_type = "Gateway"
  vpc_endpoint_service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_tags = {
     "Name" = "golden_image_vpc_endpoint"
  }
}