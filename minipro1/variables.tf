variable "myVPC_tags" {
  default = {
    Name = "myVPC"
  }
  description = "VPC tags"
  type        = map(string)
}

variable "myIGW_tags" {
  default = {
    Name = "myIGW"
  }
  description = "IGW tags"
  type        = map(string)
}

variable "myPubSN_tags" {
  default = {
    Name = "myPubSN"
  }
  description = "Subnet tags"
  type        = map(string)
}

variable "myPubRT_tags" {
  default = {
    Name = "myPubRT"
  }
  description = "Routhin Table tags"
  type        = map(string)
}

variable "mySG_tags" {
  default = {
    Name = "mySG"
  }
  description = "Security Group tags"
  type        = map(string)
}

variable "myDocker_tags" {
  default = {
    Name = "myDocker"
  }
  description = "EC2 tags"
  type        = map(string)
}

