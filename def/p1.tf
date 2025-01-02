
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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "CIDR block for Public Subnet 1"
  default     = "192.168.1.0/24"
}

variable "public_subnet2_cidr" {
  description = "CIDR block for Public Subnet 2"
  default     = "192.168.2.0/24"
}

variable "instance_profile" {
  description = "Name of the IAM Instance Profile to attach to EC2 instances"
  default     = "LabInstanceProfile"
}

variable "instance_type" {
  description = "Instance type for EC2 instances (e.g., t2.micro)"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0e2c8caa4b6378d8c"
}

variable "public_key_name" {
  description = "Name of the EC2 Key Pair for public instances"
  default     = "PUBLIC"
}
