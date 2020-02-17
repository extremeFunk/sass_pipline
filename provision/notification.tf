//resource "aws_autoscaling_policy" "xyz" {
//  name                   = "ASP-policy-xyz"
//  scaling_adjustment     = 4
//  adjustment_type        = "ChangeInCapacity"
//  cooldown               = 300
//  autoscaling_group_name = "${aws_autoscaling_group.ASG.name}"
//}

resource "aws_cloudwatch_metric_alarm" "xyz" {
  alarm_name          = "terraform-test-foobar5"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.ASG.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_sns_topic.user_updates}"]
}

resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic-xyz"
}


resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = "${aws_sns_topic.user_updates.arn}"
  protocol  = "sms"
  endpoint  = "${var.phone}"
}

/*
variable "display_name" {
  type        = "string"
  description = "Name shown in confirmation emails"
}
variable "email_addresses" {
  type        = "list"
  description = "Email address to send notifications to"
  default = ["roy.barak.dev@gmail.com"]
}
variable "protocol" {
  default     = "email"
  description = "SNS Protocol to use. email or email-json"
  type        = "string"
}
variable "stack_name" {
  type = "string"
  description = "Unique Cloudformation stack name that wraps the SNS topic."
}

data "template_file" "cloudformation_sns_stack" {
//  template = "${file("${path.module}/templates/email-sns-stack.json.tpl")}"
  template = "123"
  vars = {
    display_name  = "${var.display_name}"
    subscriptions = "${join("," , formatlist("{ \"Endpoint\": \"%s\", \"Protocol\": \"%s\"  }", var.email_addresses, var.protocol))}"
  }
}
resource "aws_cloudformation_stack" "sns_topic" {
  name          = "${var.stack_name}"
  template_body = "${data.template_file.cloudformation_sns_stack.rendered}"
  tags = "${merge(
        map("Name", "${var.stack_name}")
      )}"
}
*/

