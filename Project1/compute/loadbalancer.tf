resource "aws_lb" "lb" {
    name = "loadbalancer"
    internal = false
    load_balancer_type = "application"
    
    subnets = var.public_subnetsid
    security_groups = [aws_security_group.sgforalb.id]
    tags ={
        Name = "LoadBalancer"
    }
    
  
}
resource "aws_lb_target_group" "tgforalb" {
  name = "tgforalb"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = {
    Name = "tgforalb"
  }
}
resource "aws_lb_listener" "aws_lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tgforalb.arn
  }

  tags = {
    Name = "lb_listener"
  }

}