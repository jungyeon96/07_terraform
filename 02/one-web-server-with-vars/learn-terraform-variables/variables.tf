# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Variable declarations

variable "aws_region" {
  default     = "us-east-2"
  description = "AWS 리전"
  type        = string
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
  type        = string
}

variable "instance_count" {
  default     = 2
  description = "EC2 Instance Count"
  type        = number
}

variable "enable_vpn_gateway" {
  default     = false
  description = "VPN Gateway 지원하지 않음"
  type        = bool
}

variable "private_subnet_cidr_blocks" {
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24"
  ]
  description = "Private Subnet CIDR Block List"
  type        = list(string)
}

variable "private_subnet_count" {
  default     = 2
  description = "Private Subnet Count"
  type        = number
}

variable "public_subnets_cidr_blocks" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24"
  ]
  description = "Public Subnet CIDR Block List"
  type        = list(string)
}

variable "public_subnet_count" {
  default     = 2
  description = "Public Subnet Count"
  type        = number
}

variable "resource_tags" {
  default = {
    project     = "project-alpha",
    environment = "dev"
  }
  description = "Project Tags"
  type        = map(string)
}

variable "ec2_instance_type" {
  description = "AWS EC2 유형 선택 (ex: t2.micro)"
  type        = string
}
