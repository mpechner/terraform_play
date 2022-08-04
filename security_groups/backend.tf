terraform {
  backend "s3" {
    bucket = "mikey-com-terraformstate"
    dynamodb_table = "terraform-state"
    key    = "securitygrouops"
    region = "us-east-1"
  }
}