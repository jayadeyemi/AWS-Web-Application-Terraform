# Main Terraform Configuration
# ------------------------------------------------------------------------------
# Provider Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Configuration
provider "aws" {
  region                             = var.aws_region
}

# Phase 1 Terraform Configuration
# ------------------------------------------------------------------------------
# Importing phase1 Architecture
module "p1_arch" {
  # Importing Output Directory
  output_dir                         = var.output_dir
  # Importing phase1 definitions
  subnet_1_az                        = var.subnet_1_az
  subnet_2_az                        = var.subnet_2_az

  vpc_name                           = var.vpc_name
  vpc_cidr                           = var.vpc_cidr
  public_subnet_1_cidr               = var.public_subnet_1_cidr
  public_subnet_2_cidr               = var.public_subnet_2_cidr
  private_subnet_1_cidr              = var.private_subnet_1_cidr
  private_subnet_2_cidr              = var.private_subnet_2_cidr
  db_subnet_1_cidr                   = var.db_subnet_1_cidr
  db_subnet_2_cidr                   = var.db_subnet_2_cidr

  ec2_v1_name                        = var.ec2_v1_name
  ec2_v1_key_name                    = var.ec2_v1_key_name
  ec2_v1_instance_type               = var.ec2_v1_instance_type
  ec2_v1_userdata                    = var.ec2_v1_userdata
  ec2_v1_ami_id                      = var.ec2_v1_ami_id
  # Importing phase1 Architecture
  source                             = "./env/p1"
}

# Phase 2 Terraform Configuration
# ------------------------------------------------------------------------------
# Importing phase2 definitions
module "p2_arch" {
  # Importing Output Directory
  output_dir                          = var.output_dir
  # Importing phase1 Outputs
  vpc_id                              = module.p1_arch.vpc_id
  public_subnet_1_id                  = module.p1_arch.public_subnet_1_id
  public_subnet_2_id                  = module.p1_arch.public_subnet_2_id
  ec2_v1_instance_id                  = module.p1_arch.ec2_v1_instance_id

  # Importing phase2 definitions
  subnet_1_az                         = var.subnet_1_az
  subnet_2_az                         = var.subnet_2_az

  db_instance_class                   = var.db_instance_class
  db_instance_engine                  = var.db_instance_engine
  db_instance_engine_version          = var.db_instance_engine_version
  db_subnet_group_name                = var.db_subnet_group_name
  db_subnet_group_description         = var.db_subnet_group_description
  db_security_group_name              = var.db_security_group_name
  db_security_group_description       = var.db_security_group_description
  db_security_group_ingress_cidr      = var.db_security_group_ingress_cidr
  db_security_group_ingress_port      = var.db_security_group_ingress_port
  db_security_group_egress_cidr       = var.db_security_group_egress_cidr
  db_security_group_egress_port       = var.db_security_group_egress_port
  db_instance_multi_az                = var.db_instance_multi_az
  db_instance_storage                 = var.db_instance_storage
  db_instance_storage_type            = var.db_instance_storage_type
  db_instance_backup_retention_period = var.db_instance_backup_retention_period
  db_instance_publicly_accessible     = var.db_instance_publicly_accessible
  
  db_instance_name                    = var.db_instance_name
  db_secret_name                      = var.db_secret_name
  db_username                         = var.db_username
  db_password                         = var.db_password

  cloud9_name                         = var.cloud9_name
  cloud9_ami_id                       = var.cloud9_ami_id

  ec2_v2_name                         = var.ec2_v2_name
  ec2_v2_ami_id                       = var.ec2_v2_ami_id
  ec2_v2_instance_type                = var.ec2_v2_instance_type
  ec2_v2_key_name                     = var.ec2_v2_key_name
  ec2_v2_userdata                     = var.ec2_v2_userdata

  # Importing phase2 Architecture
  source                              = "./env/p2"
}

# # Importing phase2 Architecture
# module "p2_arch" {
#   source = var.module_p2_arch
# }

# # Phase 3 Terraform Configuration
# # ------------------------------------------------------------------------------
# # Importing phase3 definitions
# module "p3" {
#   source = var.module_p3_source
# }

# # Importing phase3 Architecture
# module "p3_arch" {
#   source = var.module_p3_arch
# }