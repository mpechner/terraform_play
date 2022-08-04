# Launch Configuration

resource "aws_launch_configuration" "web" {
  name_prefix          = "web-"
  image_id             = data.aws_ami.amazon-linux-2.id
  instance_type        = "t2.micro"
  iam_instance_profile = data.aws_iam_instance_profile.ecs.name
  security_groups      = [data.aws_security_group.http.id]
  ebs_optimized        = false
  key_name             = "default"
  user_data            = file("user_data/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

# target group
resource "aws_lb_target_group" "web" {
  name        = "web"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.mikey_test.id
  target_type = "instance"
}

# elb listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

#autoscaling group
resource "aws_autoscaling_group" "web" {
  name     = "web"
  max_size = 2
  min_size = 2

  # availability_zones = ["${var.region}a", "${var.region}b"]
  vpc_zone_identifier       = [data.aws_subnet.priv_puba.id, data.aws_subnet.priv_pubb.id]
  default_cooldown          = 60
  launch_configuration      = aws_launch_configuration.web.id
  health_check_grace_period = 30
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.web.arn]
  desired_capacity          = 2
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

#app elb
resource "aws_lb" "web" {
  name               = "webelb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.http.id]
  subnets            = [data.aws_subnet.publica.id, data.aws_subnet.publicb.id]

  tags = {
    Environment = "production"
    Name        = "web"
  }
}

