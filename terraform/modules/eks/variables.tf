variable "cluster_name" {}
variable "cluster_version" {}
variable "subnet_ids" { type = list(string) }
variable "vpc_id" {}

variable "node_groups" {
  type = map(any)
}