resource "aws_security_group" "webserver" {
  vpc_id = data.aws_vpc.default.id
  name = "webserver"
  description = "webserver"

  ingress {
    protocol = "tcp"
    self = true
    from_port = 80
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    self = true
    from_port = 8080
    to_port = 8080
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    self = true
    from_port = 22
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver"
  }
}

resource "aws_iam_role" "ecs_example_ec2" {
  name = "ecs_example_ec2"
  description = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = file("IAM/ecs_example_ec2.json")
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.ecs_example_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceRole" {
  role       = aws_iam_role.ecs_example_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_example_ec2" {
  name = "ecs_exmaple_ec2"
  role = aws_iam_role.ecs_example_ec2.name

}
resource "aws_iam_role" "ecs_example_task_role" {
  name = "ecs_example_task_role"
  description = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = file("IAM/ecs_example_task_role.json")
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy2" {
  role       = aws_iam_role.ecs_example_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceRole2" {
  role       = aws_iam_role.ecs_example_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_ecs_cluster" "webserver" {
  name = "webserver"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2*x86_64*"]
  }
}

resource "aws_launch_configuration" "webserver" {
  name_prefix          = "webserver-"
  image_id             = data.aws_ami.amazon-linux-2.id
  instance_type        = "t3.medium"
  iam_instance_profile = aws_iam_instance_profile.ecs_example_ec2.name
  security_groups      = [aws_security_group.webserver.id]
  ebs_optimized        = false
  key_name             = "default"
  user_data            = file("user_data/webserver.sh")

  lifecycle {
    create_before_destroy = true
  }
}


#autoscaling group
resource "aws_autoscaling_group" "webserver" {
  name     = "webserver"
  max_size = 1
  min_size = 1

  # availability_zones = ["${var.region}a", "${var.region}b"]
  vpc_zone_identifier       = [data.aws_subnet.def_1a.id]
  default_cooldown          = 60
  launch_configuration      = aws_launch_configuration.webserver.id
  health_check_grace_period = 30
  health_check_type         = "EC2"
  desired_capacity          = 1
  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = false
  }
  tag {
    key                 = "asgroup"
    value               = "web"
    propagate_at_launch = true
  }
}

resource "aws_ecs_task_definition" "webserver" {
  family                = "webserver"
  container_definitions = file("task-definition/webserver.json")
  requires_compatibilities = ["EC2"]
  cpu = 128
  memory = 1024
  task_role_arn = aws_iam_role.ecs_example_task_role.arn
  execution_role_arn = aws_iam_role.ecs_example_task_role.arn
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a]"
  }
}

resource "aws_ecs_service" "webserver" {
  name            = "webserver"
  cluster         = aws_ecs_cluster.webserver.id
  task_definition = aws_ecs_task_definition.webserver.arn
  desired_count   = 1
  launch_type = "EC2"
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a]"
  }
}
