# output "aws_vpc_id" {
#   value = aws_vpc.vpcforwebservers.id
# }
output "webservervpcid" {
  value = aws_vpc.vpcforwebservers.id
}
output "public_subnetsid" {
  value = aws_subnet.public_subnet[*].id
}