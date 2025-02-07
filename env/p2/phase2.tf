####################################################################################################
# Phase 2 Terraform File
####################################################################################################
# Database Subnet Group
# ------------------------------------------------------------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = [var.public_subnet_1_id, var.public_subnet_2_id]
  description = "Inventory RDS Subnet Group"
}

# RDS Security Group
# ------------------------------------------------------------------------------
resource "aws_security_group" "rds_sg" {
  name        = var.db_security_group_name
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.db_security_group_name
  }
}

# EC2-v2 Security Group
# ------------------------------------------------------------------------------
resource "aws_security_group" "ec2_v2_sg" {
  name = "${var.ec2_v2_name}-SG"
  description = "Security group for Version 1 EC2 instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.ec2_v2_name}-SG"
  }
}

# Security Group Ingress Rules
# ------------------------------------------------------------------------------
# Authorize HTTP access to EC2-v2 from the Internet
resource "aws_security_group_rule" "ec2_v2_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_v2_sg.id
}
# Authorize MySQL (3306) access between EC2-v2 and RDS (applied on EC2-v2 SG)
resource "aws_security_group_rule" "ec2_v2_mysql_from_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds_sg.id
  security_group_id        = aws_security_group.ec2_v2_sg.id
}
# Authorize MySQL (3306) access on the RDS side from EC2-v2
resource "aws_security_group_rule" "rds_mysql_from_ec2_v2" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_v2_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}

# RDS Instance
# ------------------------------------------------------------------------------
resource "aws_db_instance" "rds_instance" {
  identifier              = var.db_instance_name
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  engine                  = "mysql"
  multi_az                = true    # Initially single-AZ; update to true later if needed.
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  backup_retention_period = 1
  skip_final_snapshot     = true

  tags = {
    Name = var.db_instance_name
  }
}

# Secrets Manager Secret
# ------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "db_secret" {
  name        = var.db_secret_name
  description = "Database secret for web app"
}
# Secrets Manager Secret Details
resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    user     = var.db_username,
    password = var.db_password,
    host     = aws_db_instance.rds_instance.address,
    db       = var.db_instance_name
  })
}

# EC2-Role access to Secrets Manager
# ------------------------------------------------------------------------------
resource "aws_iam_role" "ec2_role" {
  name = "InventoryServerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}
# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "labInstanceProfile"
  role = aws_iam_role.ec2_role.name
}
# IAM Policy for EC2 Role
resource "aws_iam_role_policy" "ec2_policy" {
  name = "InventoryServerPolicy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Effect   = "Allow",
        Resource = aws_secretsmanager_secret.db_secret.arn
      }
    ]
  })
}

# EC2-v2 Key Pair
# ------------------------------------------------------------------------------
resource "tls_private_key" "key_v2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Save the private key to a file
resource "aws_key_pair" "private_key_v2" {
  key_name   = var.ec2_v2_key_name
  public_key = tls_private_key.key_v2.public_key_openssh

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p env/outputs
      echo '${tls_private_key.key_v2.private_key_pem}' > env/outputs/${var.ec2_v2_key_name}.pem
      chmod 400 env/outputs/${var.ec2_v2_key_name}.pem
    EOT
  }
}

# EC2-v2 Instance
# ------------------------------------------------------------------------------
resource "aws_instance" "ec2_v2" {
  ami                    = var.ec2_v2_ami_id
  instance_type          = "t2.micro"
  key_name               = var.ec2_v2_key_name
  subnet_id              = var.public_subnet_1_id
  vpc_security_group_ids = [aws_security_group.ec2_v2_sg.id]
  user_data              = file(var.ec2_v2_userdata)
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = var.ec2_v2_name
  }
}
# Create an AMI from the EC2-v2 Instance
resource "aws_ami_from_instance" "ec2_v2_image" {
  name               = "${var.ec2_v2_name}-ami-4-asg"
  source_instance_id = aws_instance.ec2_v2.id

  depends_on = [aws_instance.ec2_v2]
}

# # Cloud9
# #------------------------------------------------------------------------------

# resource "aws_cloud9_environment_ec2" "cloud9_env" {
#   name = var.cloud9_name
#   instance_type = "t2.micro"
#   image_id = "amazonlinux-2023-x86_64"
#   automatic_stop_time_minutes = 30
#   subnet_id = var.public_subnet_1_id
#   tags = {
#     Name = var.cloud9_name
#   }
# }

# # Cloud9 Security Group
# # ------------------------------------------------------------------------------

# resource "aws_security_group" "cloud9_sg" {
#   name        = "${var.cloud9_name}-SG"
#   description = "Security group for Cloud9 environment"
#   vpc_id      = var.vpc_id

#   tags = {
#     Name = "${var.cloud9_name}-SG"
#   }
# }

# # Security Group Ingress Rules
# # ------------------------------------------------------------------------------
# Authorize SSH access to EC2-v2 from the Cloud9 security group
# resource "aws_security_group_rule" "ec2_v2_ssh_cloud9" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.cloud9_sg.id
#   security_group_id        = aws_security_group.ec2_v2_sg.id
# }
# # Authorize SSH access to Cloud9 from the EC2-v2 security group
# resource "aws_security_group_rule" "cloud9_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = aws_security_group.ec2_v2_sg.id
#   security_group_id = aws_security_group.cloud9_sg.id  
# }

# Outputs
# ------------------------------------------------------------------------------
output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.rds_instance.address
}

output "ec2_v2_public_ip" {
  description = "Public IP of the EC2-v2 instance"
  value       = aws_instance.ec2_v2.public_ip
}
output "ec2_v2_private_ip" {
  description = "Private IP of the EC2-v2 instance"
  value       = aws_instance.ec2_v2.private_ip
}
output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db_secret.arn
}

####################################################################################################
# End of Phase 2 Terraform File
####################################################################################################

