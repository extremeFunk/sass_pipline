resource "aws_launch_configuration" "app" {
  name_prefix   = "app"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.http-8080.id}"]

  provisioner "local-exec" {
    command = <<EOT
      echo [app] > app.inv
      echo ${self.associate_public_ip_address} >> app.inv
    EOT
  }
}

resource "aws_autoscaling_group" "ASG" {
  vpc_zone_identifier = ["${aws_subnet.AZ-a.id}", "${aws_subnet.AZ-b.id}"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  target_group_arns = ["${aws_lb_target_group.app.arn}"]
  launch_configuration = "${aws_launch_configuration.app.name}"
}

resource "aws_lb" "app-LB" {
  name               = "XLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.http-8080.id}"]
  subnets            = ["${aws_subnet.AZ-a.id}", "${aws_subnet.AZ-b.id}"]

  enable_deletion_protection = true
  
  tags = {
    Environment = "${var.environment_tag}"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "app"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.default.id}"
}

resource "aws_lb_listener" "Listener-app" {
  load_balancer_arn = "${aws_lb.app-LB.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.app.arn}"
  }
}
