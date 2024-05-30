# VPC 생성
# IGW 생성

# PubSN 생성
# PubRT 생성
# PubSN <-> PubRT 연결

# SG 생성
# SSH key 생성
# EC2 생성
# * user_data(docker 설치)

# PC에서 EC2 연결

##############
# 1. VPC 생성
##############

# a. VPC 생성
resource "aws_vpc" "myVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.myVPC_tags
}

# b. IGW 생성
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id
  tags   = var.myIGW_tags
}

###############
# 2. PubSN 생성
###############

# a. PubSN 생성
resource "aws_subnet" "myPubSN" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = var.myPubSN_tags
}

# b. PubRT 생성
resource "aws_route_table" "myPubRT" {
  vpc_id = aws_vpc.myVPC.id
  tags   = var.myPubRT_tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
}

# c. PubSN <-> PubRT 연결
resource "aws_route_table_association" "myPubSNassoc" {
  subnet_id      = aws_subnet.myPubSN.id
  route_table_id = aws_route_table.myPubRT.id
}

################
# 3. EC2 생성
################

# a. SG 생성
resource "aws_security_group" "mySG" {
  name        = "mySG"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  tags = var.mySG_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_inall" {
  security_group_id = aws_security_group.mySG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_outall" {
  security_group_id = aws_security_group.mySG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# b. SSH key 생성
# (*NIX) ssh-keygen -t rsa 
resource "aws_key_pair" "mypjykey" {
  key_name   = "mypjykey"
  public_key = file("~/.ssh/pjykey.pub")
}

# c. EC2 생성
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "myDocker" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mypjykey.id
  vpc_security_group_ids = [aws_security_group.mySG.id]
  subnet_id              = aws_subnet.myPubSN.id
  tags                   = var.myDocker_tags
}

# d. user_data(docker 설치)
