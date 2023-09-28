variable "name" {
    description = "VM name"
    type = string
}

variable "gce_instance" {
    description = "GCE instance type"
    type = string
    default = "e2-micro"
}

variable "image_os" {
    description = "VM image OS"
    type = string
    default = "debian-cloud/debian-11"
}

variable "vpc_network" {
    description = "VPC network name"
    type = string
}