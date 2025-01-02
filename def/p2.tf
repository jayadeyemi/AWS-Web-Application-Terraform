
variable "vpc_id" {
  description = "ID of the VPC"
}

variable "subnet1_az" {
  description = "Availability Zone for the first database subnet"
}

variable "subnet2_az" {
  description = "Availability Zone for the second database subnet"
}

variable "db_subnet1_cidr" {
  description = "CIDR block for Database Subnet 1"
}

variable "db_subnet2_cidr" {
  description = "CIDR block for Database Subnet 2"
}

variable "db_instance_type" {
  description = "Instance type for the RDS instance"
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username for the RDS instance"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database to create"
  default     = "STUDENTS"
}