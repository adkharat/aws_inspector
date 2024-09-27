aws_region     = "us-west-2"
resource_types = ["ECR", "EC2"]

amazon_ami_ec2_ami_name                    = "ami-0182f373e66f89c85" //Replace AMI value as per your region
amazon_ami_ec2_instance_type               = "t2.micro"              //Replace with c5n.4xlarge
amazon_ami_ec2_tag                         = "amazon_ami_2023_ec2"
amazon_ami_ec2_volume_type                 = "io1" //Replace with io1
amazon_ami_ec2_volume_size                 = 30    //Replace with 300
amazon_ami_ec2_root_block_device_iops      = 100   //Replace with 15000
amazon_ami_ec2_root_block_device_encrypted = true
amazon_ami_ec2_delete_on_termination       = true
amazon_ami_ec2_associate_public_ip_address = false
amazon_ami_ec2_user_data = "inspectoragent_install.sh"

ubuntu_server_ec2_ami_name                    = "ami-0e86e20dae9224db8" //Replace AMI value as per your region (Ubuntu Server 24.04 LTS) ? 
ubuntu_server_ec2_instance_type               = "t2.micro"              //Replace with c5n.4xlarge
ubuntu_server_ec2_tag                         = "Ubuntu_Server_24.04_LTS_ec2"
ubuntu_server_ec2_volume_type                 = "io1" //Replace with io1
ubuntu_server_ec2_volume_size                 = 30    //Replace with 300
ubuntu_server_ec2_root_block_device_iops      = 100   //Replace with 15000
ubuntu_server_ec2_root_block_device_encrypted = true
ubuntu_server_ec2_delete_on_termination       = true
ubuntu_server_ec2_associate_public_ip_address = false
ubuntu_server_ec2_user_data = "inspectoragent_install.sh"

windows_server_ec2_ami_name                    = "ami-07cc1bbe145f35b58"              //Replace AMI value as per your region (Windows Server 2023) ? 
windows_server_ec2_instance_type               = "t2.micro"                           //Replace with c5n.4xlarge
windows_server_ec2_tag                         = "Microsoft Windows Server 2022 Base" //Replace with 2023
windows_server_ec2_volume_type                 = "io1"                                //Replace with io1
windows_server_ec2_volume_size                 = 30                                   //Replace with 300
windows_server_ec2_root_block_device_iops      = 100                                  //Replace with 15000
windows_server_ec2_root_block_device_encrypted = true
windows_server_ec2_delete_on_termination       = true
windows_server_ec2_associate_public_ip_address = false
windows_server_ec2_user_data = "inspectoragent_install.sh"

ebs_kms_description = "kms key for EBS volume encryption"
ebs_kms_key_usage   = "ENCRYPT_DECRYPT"


ssh_sg_security_group_name                = "ssh security group"
ssh_sg_security_group_description         = "ssh security group for EC2"
ssh_sg_security_group_ingress_description = "Inbound ssh sg"
ssh_sg_security_group_ingress_to_port     = 22
ssh_sg_security_group_ingress_from_port   = 22

http_sg_security_group_name                = "http security group"
http_sg_security_group_description         = "http security group for EC2"
http_sg_security_group_ingress_description = "Inbound http sg"
http_sg_security_group_ingress_to_port     = 80
http_sg_security_group_ingress_from_port   = 80

https_sg_security_group_name                = "https security group"
https_sg_security_group_description         = "https security group for EC2"
https_sg_security_group_ingress_description = "Inbound http sg"
https_sg_security_group_ingress_to_port     = 443
https_sg_security_group_ingress_from_port   = 443

ssm_role_name = "ssm_rol_for_ec2"
image_builder_infra_config_role_name = "image_builder_infra_config_role"
ssm_iam_instance_profile_name = "ssm_iam_instance_profile"
image_builder_infra_config_iam_policy_arn = ["arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder", "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

package_s3_bucket_name = "ec2inspackagebucket0"
# package_s3_bucket_prefix = "ubuntu" 

ubuntu_imagebuilder_image_recipe_name = "ubuntu_receipe"