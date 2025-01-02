
variable "vpc_id" {
  description = "ID of the VPC"
}

variable "public_subnet1_id" {
  description = "ID of Public Subnet 1"
}

variable "public_subnet2_id" {
  description = "ID of Public Subnet 2"
}

variable "private_subnet1_id" {
  description = "ID of Private Subnet 1"
}

variable "private_subnet2_id" {
  description = "ID of Private Subnet 2"
}

variable "instance_type" {
  description = "Instance type for Auto Scaling Group"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
}

variable "instance_profile" {
  description = "Name of the IAM Instance Profile to attach to EC2 instances"
  
}
