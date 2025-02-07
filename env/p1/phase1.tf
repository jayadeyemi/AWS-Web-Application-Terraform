####################################################################################################
# Phase 1 Terraform File
####################################################################################################
# VPC & IGW
# ------------------------------------------------------------------------------
# VPC
resource "aws_vpc" "proj_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.proj_vpc.id

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-IGW"
  }
}

# Subnets
# ------------------------------------------------------------------------------
# Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.proj_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.subnet_1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-Pub-Sub-1"
  }
}

# Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.proj_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.subnet_2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-Pub-Sub-2"
  }
}

# Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.proj_vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.subnet_1_az

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-Priv-Sub-1"
  }
  
}

# Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.proj_vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.subnet_2_az

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-Priv-Sub-2"
  }
}

# Database Subnet 1
resource "aws_subnet" "db_subnet_1" {
  vpc_id     = aws_vpc.proj_vpc.id
  cidr_block = var.db_subnet_1_cidr
  availability_zone = var.subnet_1_az

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-DB-Sub-1"
  }
}

# Database Subnet 2
resource "aws_subnet" "db_subnet_2" {
  vpc_id     = aws_vpc.proj_vpc.id
  cidr_block = var.db_subnet_2_cidr
  availability_zone = var.subnet_2_az

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-DB-Sub-2"
  } 
}
# NAT Gateways and Elastic IP
# ------------------------------------------------------------------------------
# Elastic IP for NAT Gateway 1
resource "aws_eip" "nat_eip_1" {
}

# Elastic IP for NAT Gateway 2
resource "aws_eip" "nat_eip_2" {
}

# NAT Gateway 1
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-NAT-GW-1"
  }
}

# NAT Gateway 2
resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-NAT-GW-2"
  }
}

# Route Tables
# ------------------------------------------------------------------------------
# Public Route Table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.proj_vpc.id

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-Pub-rtb"
  }
}

# Private Route Table 1
resource "aws_route_table" "private_rtb_1" {
  vpc_id = aws_vpc.proj_vpc.id

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-Priv-rtb-1"
  }
}

# Private Route Table 2
resource "aws_route_table" "private_rtb_2" {
  vpc_id = aws_vpc.proj_vpc.id

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-Priv-rtb-2"
  }
}

# Database Route Table
resource "aws_route_table" "db_rtb" {
  vpc_id = aws_vpc.proj_vpc.id

  tags = {
    Name = "${aws_vpc.proj_vpc.tags["Name"]}-DB-rtb"
  }
}

# Route Table Associations 
# ------------------------------------------------------------------------------
# Public Subnet 1 Association with Public Route Table
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rtb.id
}

# Public Subnet 2 Association with Public Route Table
resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rtb.id
}

# Private Subnet 1 Association with Private Route Table 1
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rtb_1.id
}

# Private Subnet 2 Association with Private Route Table 2
resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rtb_2.id
}

# Database Subnet 1 Association with Database Route Table
resource "aws_route_table_association" "db_subnet_1_association" {
  subnet_id      = aws_subnet.db_subnet_1.id
  route_table_id = aws_route_table.db_rtb.id
}

resource "aws_route_table_association" "db_subnet_2_association" {
  subnet_id      = aws_subnet.db_subnet_2.id
  route_table_id = aws_route_table.db_rtb.id
}

# Route Table Routes
# ------------------------------------------------------------------------------
# Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Private Route 1
resource "aws_route" "private_route_1" {
  route_table_id         = aws_route_table.private_rtb_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
}

# Private Route 2
resource "aws_route" "private_route_2" {
  route_table_id         = aws_route_table.private_rtb_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_2.id
}

# Security Groups
# ------------------------------------------------------------------------------
# EC2 version 1 Security Group
resource "aws_security_group" "ec2_v1_sg" {
  name = "${var.ec2_v1_name}-SG"
  vpc_id      = aws_vpc.proj_vpc.id
  description = "Security group for Version 1 EC2 instance"

  tags = {
    Name = "${var.ec2_v1_name}-SG"
  }
   # Ingress rule: Allow inbound traffic from the internet (0.0.0.0/0 for all IP addresses)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP
  }

  # Egress rule: Allow outbound traffic to the internet (0.0.0.0/0)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound to the internet
  }
}

# Key Pair
# ------------------------------------------------------------------------------
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "public_key" {
  key_name   = var.ec2_v1_key_name
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p env/outputs
      echo '${tls_private_key.key.private_key_pem}' > env/outputs/${var.ec2_v1_key_name}.pem
      chmod 400 env/outputs/${var.ec2_v1_key_name}.pem
    EOT
  }
}

# Version 1 EC2 Instance
# ------------------------------------------------------------------------------
resource "aws_instance" "ec2_v1_instance" {
  ami                         = var.ec2_v1_ami_id
  instance_type               = var.ec2_v1_instance_type
  subnet_id                   = aws_subnet.public_subnet_2.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.public_key.key_name
  security_groups             = [aws_security_group.ec2_v1_sg.id]

  tags = {
    Name = "Inventory-V1"
    Phase = "1"
  }

  user_data = file(var.ec2_v1_userdata)
}

# Outputs
# ------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.proj_vpc.id
}

output "public_subnet_1_id" {
  description = "The ID of Public Subnet 1"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "The ID of Public Subnet 2"
  value       = aws_subnet.public_subnet_2.id
}

output "ec2_v1_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_v1_instance.id
}

####################################################################################################
# End of Phase 1 Terraform File
####################################################################################################