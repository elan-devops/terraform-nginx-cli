
resource "aws_security_group" "default_alb_sg" {
  name        = "default-alb-sg"
  description = "Allow incoming NGINX traffic "
  vpc_id      = "${aws_vpc.default-vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "default-alb-sg"
  }
}

# using ALB - instances in private subnets
resource "aws_alb" "default_alb" {
  name = "default-aws-alb"
  security_groups = [aws_security_group.default_alb_sg.id]
  subnets = aws_subnet.default-subnets.*.id
  tags = {
    name = "default-aws-alb"
  }
}

# listener
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.default_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default_alb_tg.arn}"
    type             = "forward"
  }
}

# alb target group
resource "aws_alb_target_group" "default_alb_tg" {
  name     = "default-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.default-vpc.id}"
  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_alb_target_group_attachment" "alb_tg_attachment" {
  count            = "${length(var.AVAILABILITY_ZONES)}"
  target_group_arn = "${aws_alb_target_group.default_alb_tg.arn}"
  target_id        =  "${element(split(",", join(",", aws_instance.nginx.*.id)), count.index)}"
  port             = 80
}

resource "aws_launch_configuration" "lc" {
  image_id               = var.AMI
  instance_type          = "t2.micro"
  security_groups        = ["${aws_security_group.default-sg.id}"]
  user_data              = "${file("nginx.sh")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "default-autoscaling-group"
  launch_configuration = aws_launch_configuration.lc.id
  target_group_arns = ["${aws_alb_target_group.default_alb_tg.arn}"]
  vpc_zone_identifier       = aws_subnet.default-subnets.*.id

  desired_capacity = 2
  max_size = 6
  min_size = 1

  health_check_type = "EC2"
  tag {
    key = "name"
    value = "default-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "demo_asg_attachment" {
  alb_target_group_arn   = aws_alb_target_group.default_alb_tg.arn
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

output "url" {
  value = "http://${aws_alb.default_alb.dns_name}/"
}