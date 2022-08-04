variable "defaultkey" {
  default = "mikey"
}

variable "policy_bastion_ssh_privatekey" {
  default = "arn:aws:iam::990880295272:policy/bastion_ssh_privatekey"
}

variable "region" {
  default = "us-east-1"
}

variable "cidr" {
  default = "10.10.0.0/16"
}

variable "public1" {
  default = "10.10.1.0/24"
}

variable "pub_priv1" {
  default = "10.10.2.0/24"
}

