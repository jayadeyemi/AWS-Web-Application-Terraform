terraform {
    required_version = ">= 1.0.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "aws" {
  region = "us-east-1" # Adjust the region as needed
}

variable "vpccidr" {
  default = "192.168.0.0/16"
}

variable "pub_subnet1_cidr" {
  default = "192.168.1.0/24"
}

variable "pub_subnet2_cidr" {
  default = "192.168.2.0/24"
}

variable "priv_subnet1_cidr" {
  default = "192.168.3.0/24"
}

variable "priv_subnet2_cidr" {
  default = "192.168.4.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0e2c8caa4b6378d8c"
}

variable "key_pair_name" {
  default = "PUBLIC" # Replace with your key pair name
}

variable "user_data" {
  default = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nodejs npm mysql-server
    # Setup and configure the application here
  EOF
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Inventory-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Inventory-IGW"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Inv-Pub-Sub1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Inv-Pub-Sub2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-SG"
  }
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = aws_subnet.public1.id
  security_groups        = [aws_security_group.ec2_sg.name]
  associate_public_ip_address = true
  user_data              = var.user_data

  tags = {
    Name = "Inventory-EC2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
  description = "Public IP of the EC2 instance"
}
