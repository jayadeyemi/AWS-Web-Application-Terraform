############################################################
# Terraform & Provider Configuration
############################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

############################################################
# VPC
############################################################
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

############################################################
# Internet Gateway & Attachments
############################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

############################################################
# Elastic IPs (for NAT)
############################################################
resource "aws_eip" "nat_eip1" {
  vpc = true

  tags = {
    Name = "${var.vpc_name}-EIP1"
  }
}

resource "aws_eip" "nat_eip2" {
  vpc = true

  tags = {
    Name = "${var.vpc_name}-EIP2"
  }
}

############################################################
# Public Subnets
############################################################
resource "aws_subnet" "pub_subnet1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block             = var.pub_subnet1_cidr
  availability_zone      = var.subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.pub_subnet1_name
  }
}

resource "aws_subnet" "pub_subnet2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block             = var.pub_subnet2_cidr
  availability_zone      = var.subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.pub_subnet2_name
  }
}

############################################################
# Private Subnets
############################################################
resource "aws_subnet" "priv_subnet1" {
  vpc_id             = aws_vpc.main_vpc.id
  cidr_block         = var.priv_subnet1_cidr
  availability_zone  = var.subnet1_az

  tags = {
    Name = var.priv_subnet1_name
  }
}

resource "aws_subnet" "priv_subnet2" {
  vpc_id             = aws_vpc.main_vpc.id
  cidr_block         = var.priv_subnet2_cidr
  availability_zone  = var.subnet2_az

  tags = {
    Name = var.priv_subnet2_name
  }
}

############################################################
# NAT Gateways
############################################################
resource "aws_nat_gateway" "nat_gw1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = aws_subnet.pub_subnet1.id

  tags = {
    Name = "${var.subnet1_az}-NAT"
  }
}

resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = aws_subnet.pub_subnet2.id

  tags = {
    Name = "${var.subnet2_az}-NAT"
  }
}

############################################################
# Route Tables
############################################################
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-Pub-Route-Table"
  }
}

resource "aws_route_table" "priv_route_table1" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-Priv-Route-Table1"
  }
}

resource "aws_route_table" "priv_route_table2" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-Priv-Route-Table2"
  }
}

############################################################
# Route Table Associations
############################################################
resource "aws_route_table_association" "pub_rta1" {
  subnet_id      = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "pub_rta2" {
  subnet_id      = aws_subnet.pub_subnet2.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "priv_rta1" {
  subnet_id      = aws_subnet.priv_subnet1.id
  route_table_id = aws_route_table.priv_route_table1.id
}

resource "aws_route_table_association" "priv_rta2" {
  subnet_id      = aws_subnet.priv_subnet2.id
  route_table_id = aws_route_table.priv_route_table2.id
}

############################################################
# Public Route
############################################################
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.pub_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

############################################################
# Private Routes
############################################################
resource "aws_route" "private_route1" {
  route_table_id         = aws_route_table.priv_route_table1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw1.id
}

resource "aws_route" "private_route2" {
  route_table_id         = aws_route_table.priv_route_table2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw2.id
}

############################################################
# Security Groups
############################################################
resource "aws_security_group" "ec2_v1_sg" {
  name        = var.ec2_v1_sg_name
  description = "EC2 V1 Security Group"
  vpc_id      = aws_vpc.main_vpc.id

  # Example rule: allow inbound on port 80 from anywhere
  ingress {
    description = "Allow HTTP inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example egress: allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.ec2_v1_sg_name
  }
}

############################################################
# EC2 V1 Instance
############################################################
resource "aws_instance" "ec2_v1_instance" {
  ami                         = var.ec2_instance_ami_id
  instance_type               = var.instance_type_v1
  iam_instance_profile        = var.ec2_instance_profile
  key_name                    = var.public_key_pair_name
  subnet_id                   = aws_subnet.pub_subnet2.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_v1_sg.id]

  tags = {
    Name  = var.ec2_v1_name
    Phase = "1"
  }

  user_data = <<-EOF
    #!/bin/bash -xe
    apt update -y
    apt install nodejs unzip wget npm mysql-server -y

    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-91571/1-lab-capstone-project-1/code.zip -P /home/ubuntu
    cd /home/ubuntu
    unzip code.zip -x "resources/codebase_partner/node_modules/*"

    cd resources/codebase_partner
    npm install aws aws-sdk

    # Setup MySQL
    mysql -u root -e "CREATE USER 'nodeapp' IDENTIFIED WITH mysql_native_password BY 'student12';"
    mysql -u root -e "GRANT ALL PRIVILEGES on *.* to 'nodeapp'@'%';"
    mysql -u root -e "CREATE DATABASE STUDENTS;"
    mysql -u root -e "USE STUDENTS; CREATE TABLE students(
      id INT NOT NULL AUTO_INCREMENT,
      name VARCHAR(255) NOT NULL,
      address VARCHAR(255) NOT NULL,
      city VARCHAR(255) NOT NULL,
      state VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL,
      phone VARCHAR(100) NOT NULL,
      PRIMARY KEY (id)
    );"

    sed -i 's/.*bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
    systemctl enable mysql
    service mysql restart

    export APP_DB_HOST=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
    export APP_DB_USER=nodeapp
    export APP_DB_PASSWORD=student12
    export APP_DB_NAME=STUDENTS
    export APP_PORT=80
    npm start &

    echo '#!/bin/bash -xe
    cd /home/ubuntu/resources/codebase_partner
    export APP_PORT=80
    npm start' > /etc/rc.local
    chmod +x /etc/rc.local
  EOF
}

############################################################
# Phase2 Stack (as a placeholder)
############################################################
# In Terraform, if you want to create a nested stack or 
# run a second template, you either replicate its resources 
# here or call an external module. The snippet below is 
# a placeholder to show how you might reference your 
# existing S3 template if you were still leveraging 
# CloudFormation from Terraform.

resource "aws_cloudformation_stack" "phase2" {
  name          = "Phase2Stack"
  template_url  = "${var.stack_url}Phase2.yml"

  # Example parameters you might pass into the CF stack:
  parameters = {
    MainVPC               = aws_vpc.main_vpc.id
    VPCName               = var.vpc_name
    Subnet1AZ             = var.subnet1_az
    Subnet2AZ             = var.subnet2_az
    DBSubnet1CIDR         = var.db_subnet1_cidr
    DBSubnet2CIDR         = var.db_subnet2_cidr
    DBSubnet1Name         = var.db_subnet1_name
    DBSubnet2Name         = var.db_subnet2_name
    PUBLICKEYPAIRNAME     = var.public_key_pair_name
    PRIVATEKEYPAIRNAME    = var.private_key_pair_name
    INSTANCETYPE2         = var.instance_type_v2
    INSTANCETYPE3         = var.instance_type_v3
    DBINSTANCETYPE        = var.db_instance_type
    EC2INSTANCE2AMIID     = var.ec2_instance2_ami_id
    EC2InstanceProfile    = var.ec2_instance_profile
    EC2V2NAME             = var.ec2_v2_name
    EC2V3NAME             = var.ec2_v3_name
    ASGNAME               = var.asg_name
    RDSINSTANCEIDENTIFIER = var.db_instance_identifier
    AUTOSCALINGTARGET     = var.autoscaling_target
    EC2V2SGNAME           = var.ec2_v2_sg_name
    ASGSGName             = var.asg_sg_name
    LBSGName              = var.lb_sg_name
    DBSGName              = var.db_sg_name
    EC2V1SecurityGroup    = aws_security_group.ec2_v1_sg.id
    PubSubnet1            = aws_subnet.pub_subnet1.id
    PubSubnet2            = aws_subnet.pub_subnet2.id
    PrivSubnet1           = aws_subnet.priv_subnet1.id
    PrivSubnet2           = aws_subnet.priv_subnet2.id
    SECRETNAME            = var.db_secret_name
    SECRETUSERNAME        = var.db_secret_user
    SECRETPASSWORD        = var.db_secret_password
    SECRETDBNAME          = var.db_secret_db_name
    SECRETDESCRIPTION     = var.db_secret_description
    EC2V1PrivateIP        = aws_instance.ec2_v1_instance.private_ip
    PHASE3STACKURL        = "${var.stack_url}Phase3.yml"
    STACKURL              = "${var.stack_url}Phase2.yml"
  }

  depends_on = [aws_instance.ec2_v1_instance]
}
