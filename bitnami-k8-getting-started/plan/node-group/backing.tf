terraform {
  backend "s3" {
    bucket = "mikey-com-terraformstate"
    key    = "bitnami-k8-getting-started/plan/node-group"
    region = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}