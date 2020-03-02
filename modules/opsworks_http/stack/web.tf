data "aws_opsworks_"

resource "aws_opsworks_static_web_layer" "web" {
  stack_id = aws_opsworks_stack.main.id
  name = "web servers"
  install_updates_on_boot = true
  use_ebs_optimized_instances = true
  auto_assign_public_ips = true
}