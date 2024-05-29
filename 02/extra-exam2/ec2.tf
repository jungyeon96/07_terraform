provider "aws" {
  region = "us-east-2"
}
# EC2 인스턴스 AMI ID를 위한 Data Source 조회

data "aws_ami" "amazonLinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240528.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

# EC2 생성
resource "aws_instance" "myInstance" {
  ami           = data.aws_ami.amazonLinux.id
  instance_type = "t2.micro"

  tags = {
    Name = "myInstance"
  }
}

output "ami_id" {
  value       = aws_instance.myInstance.ami
  description = "value"
}
