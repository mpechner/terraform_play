variable "profile" {
  default = "default"
}
variable "region" {
  default = "us-east-1"
}
variable "defaultkey" {
  default = "mikey"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

#10.0.0.0 - 10.0.0.127
variable "publica" {
  default = "10.0.0.0/25"
}

# 10.0.0.128 - 10.0.0.255
variable "publicb" {
  default = "10.0.0.128/25"
}

# 10.0.1.0 - 10.0.1.255
variable "pub_priva" {
  default = "10.0.1.0/24"
}

# 10.0.2.0 - 10.0.2.255
variable "pub_privb" {
  default = "10.0.2.0/24"
}

# 10.0.3.0 - 10.0.3.255
variable "pub_privc" {
  default = "10.0.3.0/24"
}

# 10.0.4.0 - 10.0.4.127
variable "publicc" {
  default = "10.0.4.0/25"
}

# open 10.0.4.128 - 10.0.255.255

#
# Secondary CIDR
variable "eks_cidr" {
  default = "100.64.0.0/16"
}
variable "pub_priva_eks" {
  default = "100.64.0.0/19"
}
variable "pub_privb_eks" {
  default = "100.64.32.0/19"
}
variable "pub_privc_eks" {
  default = "100.64.64.0/19"
}