# Region & Availability Zones
variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region to deploy the resources."
}
variable "subnet1_az" {
  description = "Availability Zone for the first public subnet"
  default     = "us-east-1a"
}
variable "subnet2_az" {
  description = "Availability Zone for the second public subnet"
  default     = "us-east-1b"
}

# VPC & Subnet Details
# ------------------------------------------------------------------------------
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
variable "public_subnet1_cidr" {
  description = "CIDR block for Public Subnet 1"
  default     = "192.168.1.0/24"
}
variable "public_subnet2_cidr" {
  description = "CIDR block for Public Subnet 2"
  default     = "192.168.2.0/24"
}
# Private Subnets
variable "private_subnet1_cidr" {
  description = "CIDR block for Private Subnet 1"
  default     = "192.168.3.0/24"
}
variable "private_subnet2_cidr" {
  description = "CIDR block for Private Subnet 2"
  default     = "192.168.4.0/24"
}
variable "db_subnet1_cidr" {
  description = "CIDR block for DB Subnet 1"
  default     = "192.168.5.0/24"  
}
variable "db_subnet2_cidr" {
  description = "CIDR block for DB Subnet 2"
  default     = "192.168.6.0/24"
}
# EC2 Instance Details
variable "ec2_v1_name" {
  description = "Name of the EC2 instance"
  default     = "Inventory-V1"  
}
variable "public_keypair_name" {
  description = "Name of the EC2 Key Pair for public instances"
  default     = "PUBLIC"
}
variable "ec2_v1_instance_type" {
  description = "Instance type for EC2 instances (e.g., t2.micro)"
  default     = "t2.micro"
}
variable "ec2_v1_userdata" {
  description = "Path to the user data script for EC2 instances"
  default     = "scripts/ec2_v1_userdata.sh"
}
variable "ec2_v1_ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0e2c8caa4b6378d8c"
}
