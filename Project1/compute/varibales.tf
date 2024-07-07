variable "vpc_id" {
  type = string
}
variable "public_subnetsid" {
  type = list(string)
}
variable "image_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "private_subnetsid" {
  type = list(string)
}