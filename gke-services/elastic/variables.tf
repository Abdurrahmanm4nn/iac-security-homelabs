variable "project" {
  description = "Project ID / name"
  type = string
}

variable "region" {
  description = "Name of the VPC network of the cluster"
  type = string
}

variable "address_name" {
  description = "Value of the IP Address Name"
  type = string
}

variable "network_tier" {
  description = "IP Network tier"
  type = string
}

variable "elastic_port" {
  description = "Port to expose elastic"
  type = number
}

variable "kibana_port" {
  description = "Port to expose kibana"
  type = number
}