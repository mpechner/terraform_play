terraform {
  backend "s3" {
    bucket = "mikey-com-terraformstate"
    key    = "us-east-1/key_pair"
    region = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}