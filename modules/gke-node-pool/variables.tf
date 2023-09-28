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

variable "version_prefix" {
  description = "value of the version prefix"
  type = string
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

variable "gke_machine_type" {
  description = "gke machine type"
  type = string
  default = "n1-standard-1"
}

variable "node_image_type" {
  description = "value of the node image type"
  type = string
  default = "COS_CONTAINERD"
}