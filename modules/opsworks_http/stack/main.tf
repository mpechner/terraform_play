data "aws_iam_role" "opsworks" {
  name = "aws-opsworks-service-role"
}

data "aws_iam_instance_profile" "instance_opsworks" {
  name = "aws-opsworks-ec2-role"
}
resource "aws_opsworks_stack" "main" {
  name                         = "test-http"
  region                       = "us-east-1"
  service_role_arn             = data.aws_iam_role.opsworks.arn
  default_instance_profile_arn = data.aws_iam_instance_profile.instance_opsworks.arn
  agent_version = "LATEST"
  default_availability_zone = "us-east-1a"
  default_ssh_key_name = "default"
  default_os = "Amazon Linux 2"
  configuration_manager_version = "12"
  tags = {
    stack_name = "http-terraform-stack"
  }

  custom_json = <<EOT
{
 "foobar": {
    "version": "1.0.0"
  }
}
EOT
}