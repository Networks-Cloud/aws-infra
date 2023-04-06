resource "aws_security_group" "load-balancer-security-group" {
  name_prefix = "load-balancer-security-group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vishal.id
  tags = {
    "Name" = "load balancer"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

resource "aws_autoscaling_group" "asg" {

  name = "csye6225-asg-spring2023"


  tag {

    key = "Name"

    value = "ASG"

    propagate_at_launch = true

  }

  desired_capacity = 1 # Replace with your desired desired capacity

  min_size = 1 # Replace with your desired minimum size

  max_size = 3 # Replace with your desired maximum size

  vpc_zone_identifier = [for o in aws_subnet.public : o.id]

  health_check_type = "ELB"

  launch_template {

    id = aws_launch_template.ec2-template.id

    version = "$Latest"

  }

  target_group_arns = [

    aws_lb_target_group.alb_tg.arn

  ]

}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy

# resource "aws_autoscaling_policy" "asg_cpu_policy" {

#   name = "csye6225-asg-cpu"

#   autoscaling_group_name = aws_autoscaling_group.asg.name

#   adjustment_type = "ChangeInCapacity"

#   policy_type = "TargetTrackingScaling"

#   # CPU Utilization is above 40%

#   target_tracking_configuration {

#     predefined_metric_specification {

#       predefined_metric_type = "ASGAverageCPUUtilization"

#     }

#     target_value = 5.0

#   }

# }



resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 10
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "10"
  statistic           = "Average"
  threshold           = "2"
  alarm_description   = "Scale up when average CPU usage is greater than 5%"
  #alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn]
  alarm_actions             = ["${aws_autoscaling_policy.scale_up_policy.arn}"]
  insufficient_data_actions = []
}



resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Scale down when average CPU usage is below 3%"
  #alarm_actions       = [aws_autoscaling_policy.scale_down_policy.arn]
  alarm_actions = ["${aws_autoscaling_policy.scale_down_policy.arn}"]
}

resource "aws_autoscaling_attachment" "asg_lb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.alb_tg.arn
}

