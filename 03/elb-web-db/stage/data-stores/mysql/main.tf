# 프로바이더(리전) 설정
terraform {
  backend "s3" {
    bucket         = "mybucket-sol"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "myDyDB_remote_state"
  }
}

provider "aws" {
  region = "us-east-2"
}

# DB 인스턴스 생성
resource "aws_db_instance" "mydbInstance" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  db_name  = "mydb"
  username = var.dbuser
  password = "password"
}
