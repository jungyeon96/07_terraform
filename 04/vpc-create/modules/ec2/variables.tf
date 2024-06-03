variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 instance type"
  type        = string
}

variable "instance_tags" {
  default     = { Name = "web" }
  description = "Instance Tags"
  type        = map(string)
}

variable "instance_count" {
  default     = 2
  description = "Instance Count"
  type        = number
}

variable "subnet_id" {
  description = "(Required) VPC Subnet ID"
  type        = string
}
