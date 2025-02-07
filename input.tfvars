####################################################################################
# Variable Overrides
####################################################################################
# Region and AZs
# ---------------------------------------------------------------------------------
aws_region          = "us-east-1"
subnet1_az          = "us-east-1a"
subnet2_az          = "us-east-1b"

# Phase 1 Overrides
# ---------------------------------------------------------------------------------
vpc_name            =" Inv-VPC"
vpc_cidr            = "192.168.0.0/16"

pub_subnet1_cidr    = "192.168.1.0/24"
pub_subnet2_cidr    = "192.168.2.0/24"
priv_subnet1_cidr   = "192.168.3.0/24"
priv_subnet2_cidr   = "192.168.4.0/24"
db_subnet1_cidr     = "192.168.5.0/24"
db_subnet2_cidr     = "192.168.6.0/24"

ec2_v1_name         = "Inventory-V1"
ec2_v1_key_name     = "PUBLIC"
ec2_v1_instance_type= "t2.micro"
ec2_v1_userdata     = "./env/scripts/ec2_v1_userdata.sh"
ec2_v1_ami_id       = "ami-04b4f1a9cf54c11d0"


# Phase 2 Overrides
# ---------------------------------------------------------------------------------
ec2_v2_name         = "Inventory-V2"
ec2_v2_instance_type= "t2.micro"
ec2_v2_ami_id       = "ami-04b4f1a9cf54c11d0"
ec2_v2_userdata     = "./env/scripts/ec2_v2_userdata.sh"
ec2_v2_key_name     = "PRIVATE"

# cloud9_name         = "Inventory-Cloud9"
# cloud9_ami_id       = "amazonlinux-2023-x86_64"

module_p3_arch      = "./env/p3"
sample_entries      = "./env/scripts/sample_entries.sql"

db_instance_name                    = "inventory-db"
db_instance_class                   = "db.t2.micro"
db_instance_storage                 = 20
db_instance_engine                  = "mysql"
db_instance_engine_version          = 8.0
db_instance_multi_az                = false
db_instance_storage_type            = "gp2"
db_instance_backup_retention_period = 7
db_instance_publicly_accessible     = false

db_subnet_group_name                = "db-subnet-group"
db_security_group_name              = "Inv-DB-SG"
db_security_group_ingress_port      = 3306
db_security_group_egress_port       = 3306

# Phase 3 Overrides
# ---------------------------------------------------------------------------------
asg_instance_type   = "t2.micro"
asg_name            = "Inventory-ASG"
asg_config          = "./env/scripts/config.json"

####################################################################################
# Secrets
####################################################################################
# db_username         = "" # secret, uncomment and fill to override
# db_password         = "" # secret, uncomment and fill to override
# db_name             = "students"
# db_secret_name      = "MyDBSecret"

####################################################################################
# End of File
####################################################################################