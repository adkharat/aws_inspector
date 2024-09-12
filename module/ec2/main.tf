resource "aws_instance" "example_server" {
  ami           =  var.aws_instance_ami_name
  instance_type =  var.aws_instance_type

  tags = {
    Name = var.aws_instance_ami_tag
  }
}