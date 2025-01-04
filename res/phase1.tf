# Phase 1 Terraform Configuration
module "p1" {
  source = "../def/p1"
  
}

resource "aws_vpc" "main" {
  cidr_block           = vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${aws_vpc.main.tags["Name"]}-IGW"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = public_subnet1_cidr
  availability_zone       = subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "Inv-Pub-Sub1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = public_subnet2_cidr
  availability_zone       = subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "Inv-Pub-Sub2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${aws_vpc.main.tags["Name"]}-Pub-Route-Table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_sg" {
  vpc_id      = aws_vpc.main.id
  description = "Security group for EC2 instances"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-V1-SG"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = ami_id
  instance_type               = instance_type
  subnet_id                   = aws_subnet.public_subnet2.id
  associate_public_ip_address = true
  key_name                    = public_key_name
  iam_instance_profile        = instance_profile

  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "Inventory-V1"
    Phase = "1"
  }

  user_data = file("scripts/ec2_v1_userdata.sh")
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet1_id" {
  description = "The ID of Public Subnet 1"
  value       = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  description = "The ID of Public Subnet 2"
  value       = aws_subnet.public_subnet2.id
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}
