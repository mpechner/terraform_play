resource aws_launch_template  eks_node {
  name = var.template_name
  update_default_version = true
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  image_id = "ami id"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.volume_size
      encrypted = true
      kms_key_id = data.aws_kms_alias.default_kms.id
      delete_on_termination = true
    }
    ebs_optimized = true
    instance_type  = var.instancetype
  }
  network_interfaces {
    associate_public_ip_address = false
    vpc_security_group_ids = var.security_groups
  }
  user_data = filebase64( templatefile("userdata.tpl",
      { cluser_ca =  var.cluster_ca,
        cluster_endpoint = var.cluster_endpoint,
        cluster_name =  var.cluster_name,
        ami = var.ami nodegroup = var.node_group
      }
    )
  )
}