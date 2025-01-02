# Phase 3 Terraform Configuration
module "p3" {
  source = "../def/p3"
  
}

resource "aws_security_group" "lb_sg" {
  vpc_id      = vpc_id
  description = "Security group for Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB-SG"
  }
}

resource "aws_security_group" "asg_sg" {
  vpc_id      = vpc_id
  description = "Security group for Auto Scaling Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  tags = {
    Name = "ASG-SG"
  }
}

resource "aws_launch_template" "asg_lt" {
  name          = "${asg_name}-lt"
  image_id      = ami_id
  instance_type = instance_type
  key_name      = key_name

  iam_instance_profile {
    name = instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.asg_sg.id]
  }

  user_data = file("scripts/ec2_v2_userdata.sh")

  tags = {
    Name = "ASG-Launch-Template"
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [private_subnet1_id, private_subnet2_id]
  min_size            = 2
  max_size            = 6
  desired_capacity    = 2

  tag {
    key                 = "Name"
    value               = asg_name
    propagate_at_launch = true
  }
}


resource "aws_elb" "app_lb" {
  name               = "app-load-balancer"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [public_subnet1_id, public_subnet2_id]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "App-Load-Balancer"
  }
}

output "asg_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.asg_lt.id
}

output "load_balancer_dns" {
  description = "DNS Name of the Load Balancer"
  value       = aws_elb.app_lb.dns_name
}
