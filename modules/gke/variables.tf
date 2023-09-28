variable "project" {
  description = "value of the project id"
  type = string
}

variable "region" {
  description = "GKE cluster region"
  type = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type = string
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type = number
  default = 1
}

variable "disk_size" {
  description = "Node configuration"
  type = number
  default = 10
}

variable "disk_type" {
  description = "Node configuration"
  type = string
  default = "pd-standard"
}

variable "remove_default_node_pool" {
  description = "Remove default node pool {true|false}"
  type = bool
}

variable "network" {
  description = "VPC network name"
  type = string
}

variable "subnetwork" {
  description = "VPC subnetwork name"
  type = string
}