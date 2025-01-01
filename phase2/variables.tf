variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the resources in."
  default     = "us-east-1"
}

variable "subnet1_az" {
  type        = string
  description = "Availability Zone for the first subnet."
  default     = "us-east-1a"
}

variable "subnet2_az" {
  type        = string
  description = "Availability Zone for the second subnet."
  default     = "us-east-1b"
}

variable "ec2_instance_profile" {
  type        = string
  description = "The name of the instance profile to be attached to the EC2 instances."
  default     = "LabInstanceProfile"
}

variable "autoscaling_target" {
  type        = number
  description = "The Target Value for Target Tracking Scaling Policy."
  default     = 85
}

variable "ec2_instance_ami_id" {
  type        = string
  description = "The AMI ID for the EC2 instances."
  default     = "ami-0e2c8caa4b6378d8c"
}

variable "ec2_instance2_ami_id" {
  type        = string
  description = "The AMI ID for the EC2 instances (Phase 2)."
  default     = "ami-0e2c8caa4b6378d8c"
}

variable "instance_type_v1" {
  type        = string
  description = "The instance type for the EC2 instance (Phase 1)."
  default     = "t2.micro"
}

variable "instance_type_v2" {
  type        = string
  description = "The instance type for the EC2 instance (Phase 2)."
  default     = "t2.micro"
}

variable "instance_type_v3" {
  type        = string
  description = "The instance type for the EC2 instance (Phase 3)."
  default     = "t2.micro"
}

variable "db_instance_type" {
  type        = string
  description = "The instance type for the RDS database."
  default     = "db.t3.micro"
}

variable "stack_url" {
  type        = string
  description = "S3 URL for Phase 2 or Phase 3 CloudFormation templates."
  default     = "https://cf-8569.s3.us-east-1.amazonaws.com/"
}

variable "vpc_name" {
  type        = string
  description = "VPC name."
  default     = "Inventory-VPC"
}

variable "pub_subnet1_name" {
  type        = string
  description = "Public subnet 1 name."
  default     = "Inv-Pub-Sub1"
}

variable "pub_subnet2_name" {
  type        = string
  description = "Public subnet 2 name."
  default     = "Inv-Pub-Sub2"
}

variable "priv_subnet1_name" {
  type        = string
  description = "Private subnet 1 name."
  default     = "Inv-Priv-Sub1"
}

variable "priv_subnet2_name" {
  type        = string
  description = "Private subnet 2 name."
  default     = "Inv-Priv-Sub2"
}

variable "db_subnet1_name" {
  type        = string
  description = "Database subnet 1 name."
  default     = "Inv-DB-Sub1"
}

variable "db_subnet2_name" {
  type        = string
  description = "Database subnet 2 name."
  default     = "Inv-DB-Sub2"
}

variable "ec2_v1_sg_name" {
  type        = string
  description = "EC2 Security Group name for Server V1."
  default     = "EC2-V1-SG"
}

variable "ec2_v2_sg_name" {
  type        = string
  description = "EC2 Security Group name for Server V2."
  default     = "EC2-V2-SG"
}

variable "asg_sg_name" {
  type        = string
  description = "Auto Scaling Group Security Group name."
  default     = "ASG-V3-SG"
}

variable "lb_sg_name" {
  type        = string
  description = "Load Balancer Security Group name."
  default     = "LB-V3-SG"
}

variable "db_sg_name" {
  type        = string
  description = "Database Security Group name."
  default     = "DB-SG"
}

variable "ec2_v1_name" {
  type        = string
  description = "EC2 instance 1 name."
  default     = "Inventory-V1"
}

variable "ec2_v2_name" {
  type        = string
  description = "EC2 instance 2 name."
  default     = "Inventory-V2"
}

variable "ec2_v3_name" {
  type        = string
  description = "EC2 instance 3 name (ASG)."
  default     = "Inventory-V3"
}

variable "asg_name" {
  type        = string
  description = "Auto Scaling Group name."
  default     = "Inventory-V3-ASG"
}

variable "db_instance_identifier" {
  type        = string
  description = "The name of the RDS database instance."
  default     = "InventoryDB"
}

variable "cloud9_instance_name" {
  type        = string
  description = "Cloud9 instance name."
  default     = "Cloud9-Instance"
}

variable "public_key_pair_name" {
  type        = string
  description = "The name of the EC2 Key Pair for public instances."
  default     = "PUBLIC"
}

variable "private_key_pair_name" {
  type        = string
  description = "The name of the EC2 Key Pair for private instances."
  default     = "PRIVATE"
}

variable "db_secret_name" {
  type        = string
  description = "The name of the database secret."
  default     = "Mydbsecret"
}

variable "db_secret_user" {
  type        = string
  description = "The username for the database secret."
  default     = "nodeapp"
}

variable "db_secret_password" {
  type        = string
  description = "The password for the database secret."
  default     = "student12"
}

variable "db_secret_db_name" {
  type        = string
  description = "The database name for the database secret."
  default     = "STUDENTS"
}

variable "db_secret_description" {
  type        = string
  description = "The description for the database secret."
  default     = "Database secret for web app"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default     = "192.168.0.0/16"
}

variable "pub_subnet1_cidr" {
  type        = string
  description = "Public Subnet 1 CIDR."
  default     = "192.168.1.0/24"
}

variable "pub_subnet2_cidr" {
  type        = string
  description = "Public Subnet 2 CIDR."
  default     = "192.168.2.0/24"
}

variable "priv_subnet1_cidr" {
  type        = string
  description = "Private Subnet 1 CIDR."
  default     = "192.168.3.0/24"
}

variable "priv_subnet2_cidr" {
  type        = string
  description = "Private Subnet 2 CIDR."
  default     = "192.168.4.0/24"
}

variable "db_subnet1_cidr" {
  type        = string
  description = "Database Subnet 1 CIDR."
  default     = "192.168.5.0/24"
}

variable "db_subnet2_cidr" {
  type        = string
  description = "Database Subnet 2 CIDR."
  default     = "192.168.6.0/24"
}
