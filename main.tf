# Main Terraform Configuration


module "phase1" {
  source = "./res/phase1"

  aws_region          = var.aws_region
  subnet1_az          = var.subnet1_az
  subnet2_az          = var.subnet2_az
  vpc_cidr            = var.vpc_cidr
  public_subnet1_cidr = var.public_subnet1_cidr
  public_subnet2_cidr = var.public_subnet2_cidr
  instance_profile    = var.instance_profile
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  public_key_name     = var.public_key_name
}

module "phase2" {
  source = "./res/phase2"

  vpc_id             = module.phase1.vpc_id
  subnet1_az         = var.subnet1_az
  subnet2_az         = var.subnet2_az
  db_subnet1_cidr    = var.db_subnet1_cidr
  db_subnet2_cidr    = var.db_subnet2_cidr
  db_instance_type   = var.db_instance_type
  db_username        = var.db_username
  db_password        = var.db_password
  db_name            = var.db_name
}

module "phase3" {
  source = "./res/phase3"


  vpc_id               = module.phase1.vpc_id
  public_subnet1_id    = module.phase1.public_subnet1_id
  public_subnet2_id    = module.phase1.public_subnet2_id
  private_subnet1_id   = module.phase2.db_subnet1_id
  private_subnet2_id   = module.phase2.db_subnet2_id
  instance_type        = var.asg_instance_type
  ami_id               = var.ami_id
  key_name             = var.public_key_name
  asg_name             = var.asg_name
}

output "vpc_id" {
  description = "VPC ID from Phase 1"
  value       = module.phase1.vpc_id
}

output "db_instance_endpoint" {
  description = "RDS Instance Endpoint from Phase 2"
  value       = module.phase2.db_instance_endpoint
}

output "load_balancer_dns" {
  description = "Load Balancer DNS Name from Phase 3"
  value       = module.phase3.load_balancer_dns
}
