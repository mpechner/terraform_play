
variable "template_name" {
  description = "The name of the launch template"
}

variable "iam_instance_profile" {
  description = "iam_instance_profile"
}

variable "ebs_kms_alias" {
  description = "Alias of the KMS key to use"
  default = "alias/aws/ebs"
}

variable "security_groups" {
  description = "List of security groups to apply"
  type = list(string)
}
variable "cluster_ca" {
  description = "eks cluster certificate authority data"
}

variable "cluster_endpoint" {
  description = "eks cluster endpoint"
}
variable "cluster_name" {
  description = "eks cluster name"
}

variable "ami" {
  description = "ami to use"
}
variable "volume_size" {
  description = "disk size in GB"
  default = 20
}

variable "node_group" {
  description = "Name of node group"
}

variable "instancetype" {
  description = "instance type"
  default = "t2.micro"
}