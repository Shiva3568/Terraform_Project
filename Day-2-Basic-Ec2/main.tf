#create a Ec2 instance

resource "aws_instance" "n" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
      name = "my-Ec2"
    }
  
}