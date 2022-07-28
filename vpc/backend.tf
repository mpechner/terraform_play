terraform {
  backend "s3" {
    bucket = "mikey-com-terraformstate"
    dynamodb_table = "terraform-state"
    key    = "us-east-1/vpc/demo"
    region = "us-east-1"
  }
}