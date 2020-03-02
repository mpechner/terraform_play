variable "defaultkey" {
  default = "mikey"
}

variable "region" {
  default = "us-east-1"
}

variable "cidr" {
  default = "10.10.0.0/16"
}

variable "publica" {
  default = "10.10.1.0/24"
}

variable "publicb" {
  default = "10.10.2.0/24"
}

variable "pub_priva" {
  default = "10.10.3.0/24"
}

variable "pub_privb" {
  default = "10.10.4.0/24"
}
variable "backingbucket" {
  description = "name of backing bucket"
}
variable "backingdb" {
  description = "name of backing db"

}
