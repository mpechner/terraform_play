terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1"
}
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "~/.aws/creds"
  profile = var.profile
}