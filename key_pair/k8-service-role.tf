resource "aws_key_pair" "deployer" {
  key_name   = "akey"
  public_key = file("~/.ssh/aws_pair.pub")
}