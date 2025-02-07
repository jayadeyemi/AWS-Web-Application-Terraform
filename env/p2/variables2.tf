####################################################################################################
# Variable Definitions
####################################################################################################
# Importing Output Directory
# ----------------------------------------------------------------------------------
variable "output_dir" {
  description = "Directory to store output files"
}
# Importing p1 Outputs
# ----------------------------------------------------------------------------------
variable "vpc_id" {
  description = "The ID of the VPC"
}
 
variable "public_subnet_1_id" {
  description = "The ID of Public Subnet 1"
}
variable "public_subnet_2_id" {
  description = "The ID of Public Subnet 2"
}
variable "ec2_v1_instance_id" {
  description = "The ID of EC2 Instance V1"
}

# Availability Zone Details
# ----------------------------------------------------------------------------------
variable "subnet_1_az" {
  description = "Availability Zone for the first public subnet"
}
variable "subnet_2_az" {
  description = "Availability Zone for the second public subnet"
}

# RDS Instance Details
# ----------------------------------------------------------------------------------
variable "db_instance_name" {
  description = "Name of the RDS instance"
}
variable "db_instance_class" {
  description = "Instance class for the RDS instance"
}
variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
}
variable "db_subnet_group_description" {
  description = "Description for the DB subnet group"
}
variable "db_security_group_name" {
  description = "Name of the DB security group"
}
variable "db_security_group_description" {
  description = "Description for the DB security group"
}
variable "db_security_group_ingress_cidr" {
  description = "CIDR block for ingress rules in the DB security group"
}
variable "db_security_group_ingress_port" {
  description = "Port for ingress rules in the DB security group"
}
variable "db_security_group_egress_cidr" {
  description = "CIDR block for egress rules in the DB security group"
}
variable "db_security_group_egress_port" {
  description = "Port for egress rules in the DB security group"
} 
variable "db_instance_storage" {
  description = "Allocated storage for the RDS instance in GB"
}
variable "db_instance_engine" {
  description = "Database engine for the RDS instance"
}
variable "db_instance_engine_version" {
  description = "Engine version for the RDS instance"
}
variable "db_instance_multi_az" {
  description = "Multi-AZ deployment for the RDS instance"
}
variable "db_instance_storage_type" {
  description = "Storage type for the RDS instance"
}
variable "db_instance_backup_retention_period" {
  description = "Backup retention period for the RDS instance in days"
}
variable "db_instance_publicly_accessible" {
  description = "Public accessibility for the RDS instance"
}

# EC2 Instance Details
# ----------------------------------------------------------------------------------
variable "ec2_v2_name" {
  description = "Name of the EC2 instance"
}
variable "ec2_v2_instance_type" {
  description = "Instance type for EC2 instances (e.g., t2.micro)"
}
variable "ec2_v2_userdata" {
  description = "Path to the user data script for EC2 instances"
}
variable "ec2_v2_ami_id" {
  description = "AMI ID for EC2 instances"
}
variable "ec2_v2_key_name" {
  description = "Name of the EC2 Key Pair for public instances"
}

# database connection details
# ----------------------------------------------------------------------------------
variable "db_secret_name" {
  description = "Name of the secret in Secrets Manager"
}
variable "db_username" {
  description = "Username for the RDS instance"
}
variable "db_password" {
  description = "Password for the RDS instance"
}
# Cloud9 Details
# ----------------------------------------------------------------------------------
variable "cloud9_name" {
  description = "Name of the Cloud9 environment"
  }
variable "cloud9_ami_id" {
  description = "Image ID for the Cloud9 environment"
}
####################################################################################################
# End of Variable Definitions
####################################################################################################