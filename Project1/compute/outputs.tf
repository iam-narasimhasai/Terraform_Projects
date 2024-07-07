output "alb_dns" {
  value = aws_lb.lb.dns_name
}
output "aminame" {
  value = data.aws_ami.ec2_ami.id
}