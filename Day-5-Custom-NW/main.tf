#create a vpc
resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "My_VPC"
    }
  
}

#create a public subnet
resource "aws_subnet" "test" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "Pub-Sub"
    }
  
}

#create a private subnet
resource "aws_subnet" "dev" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "Pvt-Subnet"
    }
  
}

#create Internet gateway
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "My-IG"
    }
  
}

#create a route table for public
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "Pub-RT"
    }
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
}
  
}
#create a subnet association for public
resource "aws_route_table_association" "name" {
    route_table_id = aws_route_table.name.id
    subnet_id = aws_subnet.test.id
  
}

#create Elastic IP
resource "aws_eip" "name" {
    domain = "vpc"
  
}
#create a NAT gateway
resource "aws_nat_gateway" "name" {
    subnet_id = aws_subnet.test.id
    allocation_id = aws_eip.name.id
    tags = {
      Name = "My-NAT"
    }
  
}

#create a route table for private
resource "aws_route_table" "test" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "Pvt-RT"
    }
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.name.id
}
  
}
#create a subnet associate for private
resource "aws_route_table_association" "Advika" {
    route_table_id = aws_route_table.test.id
    subnet_id = aws_subnet.dev.id
  
}

#create a security group
resource "aws_security_group" "name" {
    name = "allow all traffic"
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "My-SG"
    }
ingress{
    description = "inbound traffic"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
egress{
    description = "outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
  
}

#create a EC2 for Public
resource "aws_instance" "name" {
    ami = "ami-0453ec754f44f9a4a"
    instance_type = "t2.micro"
    key_name = "Adhya"
    subnet_id = aws_subnet.test.id
    vpc_security_group_ids = [aws_security_group.name.id]
    tags = {
      Name = "Pub-Ec2"
    }
  
}

#create a Ec2 for Private
resource "aws_instance" "name-Pvt" {
    ami = "ami-0453ec754f44f9a4a"
    instance_type = "t2.micro"
    key_name = "Adhya"
    subnet_id = aws_subnet.dev.id
    vpc_security_group_ids = [aws_security_group.name.id]
    tags = {
      Name = "Pvt-Ec2"
    }
  
}