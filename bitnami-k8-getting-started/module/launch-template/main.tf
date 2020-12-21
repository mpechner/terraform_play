resource aws_launch_template  eks_node {
  name = var.template_name
  update_default_version = true
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  ebs_optimized = true
  image_id = var.ami
  key_name = "akey"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.volume_size
      encrypted = true
      kms_key_id = data.aws_kms_alias.default_kms.id
      delete_on_termination = true
    }
  }
  network_interfaces {
    associate_public_ip_address  = false
    security_groups = var.security_groups
  }
  user_data = base64encode( templatefile("${path.module}/userdata.tpl",
      {
        cluster_ca =  var.cluster_ca,
        cluster_endpoint = var.cluster_endpoint,
        cluster_name =  var.cluster_name,
        nodegroup = var.node_group
        ami = var.ami
      }
    )
  )
}