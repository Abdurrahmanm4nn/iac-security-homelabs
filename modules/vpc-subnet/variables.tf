variable "vpc_name" {
  description = "value of the vpc name"
  type = string
}

variable "subnet_name" {
  description = "value of the subnet name"
  type = string
}

variable "region" {
  description = "VPC Subnet region"
  type = string
}

variable "cidr_range"{
  description = "VPC Subnet CIDR Range"
  type = string
}