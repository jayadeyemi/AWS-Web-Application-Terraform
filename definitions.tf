####################################################################################################
# Variable Definitions
####################################################################################################
# Importing Output Directory
# ----------------------------------------------------------------------------------
variable "output_dir" {
  description = "Directory to store output files"
}
# AWS Provider Configuration
# ----------------------------------------------------------------------------------
variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}
####################################################################################################
# Phase 1 Variables
####################################################################################################
# Region & Availability Zones
# ----------------------------------------------------------------------------------
variable "subnet_1_az" {
  description = "Availability Zone for the first public subnet"
  default     = "us-east-1a"
}
variable "subnet_2_az" {
  description = "Availability Zone for the second public subnet"
  default     = "us-east-1b"
}

# VPC & Subnet Details
# ----------------------------------------------------------------------------------
#VPC
variable "vpc_name" {
  description = "Name of the VPC"
  default     = "Inv-VPC"  
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/16"
}
#Public Subnets
variable "public_subnet_1_cidr" {
  description = "CIDR block for Public Subnet 1"
  default     = "192.168.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR block for Public Subnet 2"
  default     = "192.168.2.0/24"
}
# Private Subnets
variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
  default     = "192.168.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
  default     = "192.168.4.0/24"
}
variable "db_subnet_1_cidr" {
  description = "CIDR block for DB Subnet 1"
  default     = "192.168.5.0/24"  
}
variable "db_subnet_2_cidr" {
  description = "CIDR block for DB Subnet 2"
  default     = "192.168.6.0/24"
}

# EC2 Instance Details
# ----------------------------------------------------------------------------------
variable "ec2_v1_name" {
  description = "Name of the EC2 instance"
  default     = "Inventory-V1"  
}
variable "ec2_v1_key_name" {
  description = "Name of the EC2 Key Pair for public instances"
  default     = "PUBLIC"
}
variable "ec2_v1_instance_type" {
  description = "Instance type for EC2 instances (e.g., t2.micro)"
  default     = "t2.micro"
}
variable "ec2_v1_userdata" {
  description = "Path to the user data script for EC2 instances"
  default     = "./env/scripts/ec2_v1_userdata.sh"
}
variable "ec2_v1_ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-04b4f1a9cf54c11d0"
}

# Outputs
# ----------------------------------------------------------------------------------
variable "vpc_id" {
  description = "The ID of the VPC"
  default = ""
}
 
variable "public_subnet_1_id" {
  description = "The ID of Public Subnet 1"
  default = ""
}
variable "public_subnet_2_id" {
  description = "The ID of Public Subnet 2"
  default = ""
}
variable "ec2_v1_instance_id" {
  description = "The ID of EC2 Instance V1"
  default = ""
}

####################################################################################################
# Phase 2 variables
####################################################################################################
# RDS Instance Details
variable "db_instance_name" {
  description = "Name of the RDS instance"
  default     = "inventory-db"
}
variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  default     = "db.t2.micro"
}

variable "db_username" {
  description = "Username for the RDS instance"
}
variable "db_password" {
  description = "Password for the RDS instance"
}
variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  default     = "db-subnet-group"
}
variable "db_subnet_group_description" {
  description = "Description for the DB subnet group"
  default     = "DB Subnet Group for Inventory"
}

variable "db_security_group_name" {
  description = "Name of the DB security group"
  default     = "Inv-DB-SG"
}
variable "db_security_group_description" {
  description = "Description for the DB security group"
  default     = "DB Security Group for Inventory"
}
variable "db_security_group_ingress_cidr" {
  description = "CIDR block for ingress rules in the DB security group"
  default     = ""
}
variable "db_security_group_ingress_port" {
  description = "Port for ingress rules in the DB security group"
  default     = 3306
}
variable "db_security_group_egress_cidr" {
  description = "CIDR block for egress rules in the DB security group"
  default     = ""
}
variable "db_security_group_egress_port" {
  description = "Port for egress rules in the DB security group"
  default     = 0
} 
variable "db_instance_storage" {
  description = "Allocated storage for the RDS instance in GB"
  default     = 20
}
variable "db_instance_engine" {
  description = "Database engine for the RDS instance"
  default     = "mysql"
}
variable "db_instance_engine_version" {
  description = "Engine version for the RDS instance"
  default     = "8.0"
}
variable "db_instance_multi_az" {
  description = "Multi-AZ deployment for the RDS instance"
  default     = false
}
variable "db_instance_storage_type" {
  description = "Storage type for the RDS instance"
  default     = "gp2"
}
variable "db_instance_backup_retention_period" {
  description = "Backup retention period for the RDS instance in days"
  default     = 7
}
variable "db_instance_publicly_accessible" {
  description = "Public accessibility for the RDS instance"
  default     = false
}

# # ----------------------------------------------------------------------------------
# EC2 Instance Details
variable "ec2_v2_name" {
  description = "Name of the EC2 instance"
  default     = "Inventory-V2"
}
variable "ec2_v2_instance_type" {
  description = "Instance type for EC2 instances (e.g., t2.micro)"
  default     = "t2.micro"
}
variable "ec2_v2_userdata" {
  description = "Path to the user data script for EC2 instances"
  default     = "./env/scripts/ec2_v2_userdata.sh"
}
variable "ec2_v2_ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-04b4f1a9cf54c11d0"
}
variable "ec2_v2_key_name" {
  description = "Name of the EC2 Key Pair for public instances"
  default     = "PRIVATE"
}
# ----------------------------------------------------------------------------------
# database connection details
variable "db_secret_name" {
  description = "Name of the secret in Secrets Manager"
  default     = "MyDBSecret"
}
variable "db_name" {
  description = "Name of the database"
  default     = "inventory_db"
}
# ----------------------------------------------------------------------------------
# Cloud9 Details
variable "cloud9_name" {
  description = "Name of the Cloud9 environment"
  default     = "Inventory-Cloud9"
}
variable "cloud9_ami_id" {
  description = "Image ID for the Cloud9 environment"
  default     = "amazonlinux-2023-x86_64"
  
}
####################################################################################################
# End of File
####################################################################################################