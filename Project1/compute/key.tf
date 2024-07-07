resource "aws_key_pair" "kp" {
  key_name = "key1"
  public_key = file("${path.module}/key1.pub")
}