variable "region" {
  type = string
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "cidr_block" {
  type = string
}
variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b"]
}
variable "image_id" {
  type = string
}
variable "instance_type" {
  type = string
}