####################################################################################################
# Variable Definitions
####################################################################################################
# Importing Output Directory
# ----------------------------------------------------------------------------------
variable "output_dir" {
  description = "Directory to store output files"
}

# Availability Zones
# ------------------------------------------------------------------------------
variable "subnet_1_az" {
  description = "Availability Zone for the first public subnet"
}
variable "subnet_2_az" {
  description = "Availability Zone for the second public subnet"
}

# VPC & Subnet Details
# ------------------------------------------------------------------------------
#VPC
variable "vpc_name" {
  description = "Name of the VPC"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}
#Public Subnets
# ------------------------------------------------------------------------------
variable "public_subnet_1_cidr" {
  description = "CIDR block for Public Subnet 1"
}
variable "public_subnet_2_cidr" {
  description = "CIDR block for Public Subnet 2"
}
# Private Subnets
# ------------------------------------------------------------------------------
variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
}
variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
}
variable "db_subnet_1_cidr" {
  description = "CIDR block for DB Subnet 1"
}
variable "db_subnet_2_cidr" {
  description = "CIDR block for DB Subnet 2"
}
# EC2 Instance Details
# ------------------------------------------------------------------------------
variable "ec2_v1_name" {
  description = "Name of the EC2 instance"
}
variable "ec2_v1_key_name" {
  description = "Name of the EC2 Key Pair for ec2_v1 instance"
}
variable "ec2_v1_instance_type" {
  description = "Instance type for EC2 instances (e.g., t2.micro)"
}
variable "ec2_v1_userdata" {
  description = "Path to the user data script for EC2 instances"
}
variable "ec2_v1_ami_id" {
  description = "AMI ID for EC2 instances"
}

####################################################################################################
# End of Variable Definitions
####################################################################################################