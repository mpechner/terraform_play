resource "aws_ebs_encryption_by_default" "allvolumes" {
  enabled = true
}

data aws_kms_alias "ebs" {
  name = "alias/aws/ebs"
}

resource "aws_ebs_default_kms_key" "example" {
  key_arn = data.aws_kms_alias.ebs.arn
}