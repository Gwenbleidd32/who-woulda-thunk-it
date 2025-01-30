# Create an SNS topic for notifications
resource "aws_sns_topic" "hello" {
  name = "the0-knows"
}

# Subscribe an email to the SNS topic
resource "aws_sns_topic_subscription" "find_me" {
  topic_arn = aws_sns_topic.hello.arn
  protocol  = "email"
  endpoint  = "beron.bantonburns@gmail.com"
}

# Associate the SNS Topic with the ASG for notifications
resource "aws_autoscaling_notification" "asg_notification" {
  group_names = [aws_autoscaling_group.app1_asg.name]
  topic_arn   = aws_sns_topic.hello.arn
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
}