resource "aws_autoscaling_group" "asg" {
  min_size = 2
  max_size = 3
  desired_capacity = 2
  name = "ASGforwebservers"
  target_group_arns = [aws_lb_target_group.tgforalb.arn]
  vpc_zone_identifier = var.private_subnetsid

  launch_template {
    id = aws_launch_template.lt.id
    version = "$Latest"
  }
  health_check_type = "EC2"


}