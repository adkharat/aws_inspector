aws_region     = "us-east-1"
resource_types = ["ECR", "EC2"]

amazon_ami_ec2_ami_name                    = "ami-0182f373e66f89c85" //Replace AMI value as per your region
amazon_ami_ec2_instance_type               = "t2.micro"              //Replace with c5n.4xlarge
amazon_ami_ec2_tag                         = "amazon_ami_2023_ec2"
amazon_ami_ec2_volume_type                 = "gp2" //Replace with io1
amazon_ami_ec2_volume_size                 = 30    //Replace with 300
amazon_ami_ec2_delete_on_termination       = true
amazon_ami_ec2_associate_public_ip_address = false

ssh_sg_security_group_name                = "ssh security group"
ssh_sg_security_group_description         = "ssh security group for EC2"
ssh_sg_security_group_ingress_description = "Inbound ssh sg"
ssh_sg_security_group_ingress_to_port     = 22
ssh_sg_security_group_ingress_from_port   = 22