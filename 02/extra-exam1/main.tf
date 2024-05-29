# Default VPC -> Public Subnet
# Routing Table을 만들고 Public Subnet 연결하기

provider "aws" {
  region = "us-east-2"
}

# VPC 생성
resource "aws_vpc" "myVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "myVPC"
  }
}

# 1) Public Subnet 만들기
resource "aws_subnet" "MyPubSubnet" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "myPubSubnet"
  }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "myIGW"
  }
}

# Internet Gateway를 VPC에 연결


# 2) Routing Table을 만들고 Public Subnet 연결하기
resource "aws_route_table" "myPubRT" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }

  tags = {
    Name = "myRT"
  }
}

# Public Routing Table를 Public Subnet에 연결
resource "aws_route_table_association" "myRTass" {
  subnet_id      = aws_subnet.MyPubSubnet.id
  route_table_id = aws_route_table.myPubRT.id
}

# EC2 생성
# * ami: Amazon Linux 2023 AMI
resource "aws_instance" "myWEB" {
  ami           = "ami-0ca2e925753ca2fb4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.MyPubSubnet.id

  user_data_replace_on_change = true
  user_data                   = <<-EOF
    #!/bin/bash
    yum -y install httpd 
    echo "MyWEB" > /var/www/html/index.html
    systemctl enable --now httpd
    EOF

  tags = {
    Name = "myWEB"
  }
}

# Security Group 생성 

resource "aws_security_group" "allow_WEB" {
  name        = "allow_WEB"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  tags = {
    Name = "allow_WEB"
  }
}


# Security Group의 ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_WEB.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_WEB.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Secutiry Group의 egress rule
resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.allow_WEB.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
