# 인프라 구성 : VPC, Subnet, IGW, NAT ...
# 구성 : ELB(2) + ASG(1) 
# * 시작 템플릿
# * ASG
# * TG
# * SG
# * ELB
# * ELB Listener
# * ELB Listener Rule

# 1. 인프라 구성 : VPC, Subnet, IGW, NAT, ...
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2. 구성 : ELB(2) + ASG(1) 
# * SG for 시작 구성 (Lanch Configuration)
# * 시작 구성 (Lanch Configuration)
# * ASG
# * TG
# * SG
# * ELB
# * ELB Listener
# * ELB Listener Rule

# AMI data 생성
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Security Group 생성 for LC
resource "aws_security_group" "mySGforLC" {
  name        = "mySGforLC"
  description = "Allow WEB inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "mySGforLC"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080" {
  security_group_id = aws_security_group.mySGforLC.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.inport_web
  to_port           = var.outport_web
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {
  security_group_id = aws_security_group.mySGforLC.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.inport_ssh
  to_port           = var.outport_ssh
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.mySGforLC.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# myLC 구성
resource "aws_launch_configuration" "myLC" {
  name_prefix     = "myLC-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.mySGforLC.id]

  user_data = file("userdata.tpl")

  lifecycle {
    create_before_destroy = true
  }
}

# ASG 구성
resource "aws_autoscaling_group" "myASG" {
  name                      = "myASG"
  launch_configuration      = aws_launch_configuration.myLC.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.myTGASG.arn]
  depends_on        = [aws_lb_target_group.myTGASG]

  lifecycle {
    create_before_destroy = true
  }
}

# Target Group 생성
resource "aws_lb_target_group" "myTGASG" {
  name     = "myTGASG"
  port     = var.inport_web
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = var.inport_web
    matcher             = "200"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ELB 생성
resource "aws_lb" "myALB" {
  name               = "myALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mySGforLC.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Environment = "myALB"
  }
}

# ELB Listener 생성
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.myALB.id
  port              = var.inport_web
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myTGASG.arn
  }
}
