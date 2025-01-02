# Phase 2 Terraform Configuration

module "p3" {
  source = "../def/p3"
  
}

resource "aws_subnet" "db_subnet1" {
  vpc_id            = vpc_id
  cidr_block        = db_subnet1_cidr
  availability_zone = subnet1_az

  tags = {
    Name = "Inv-DB-Sub1"
  }
}

resource "aws_subnet" "db_subnet2" {
  vpc_id            = vpc_id
  cidr_block        = db_subnet2_cidr
  availability_zone = subnet2_az

  tags = {
    Name = "Inv-DB-Sub2"
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id      = vpc_id
  description = "Security group for RDS instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Modify as per your security requirements
  }

  tags = {
    Name = "DB-SG"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.db_subnet1.id, aws_subnet.db_subnet2.id]

  tags = {
    Name = "RDS-Subnet-Group"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier             = "inventory-db"
  instance_class         = db_instance_type
  allocated_storage      = 20
  engine                 = "mysql"
  db_name                   = db_name
  username               = db_username
  password               = db_password
  publicly_accessible    = false
  multi_az               = false
  storage_type           = "gp2"
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "InventoryDB"
  }
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.rds_instance.endpoint
}

output "db_subnet1_id" {
  description = "ID of Database Subnet 1"
  value       = aws_subnet.db_subnet1.id
}

output "db_subnet2_id" {
  description = "ID of Database Subnet 2"
  value       = aws_subnet.db_subnet2.id
}

output "db_security_group_id" {
  description = "ID of the Security Group for RDS"
  value       = aws_security_group.db_sg.id
}
