data "aws_ami" "ec2_ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
 
}
resource "aws_launch_template" "lt" {
    name = "launch_templateforhttpd"
    #image_id = var.image_id
    image_id = data.aws_ami.ec2_ami.id
    instance_type = var.instance_type

    key_name = aws_key_pair.kp.key_name
    user_data = filebase64("${path.module}/userdata.sh")
    network_interfaces {
      associate_public_ip_address = false
      security_groups = [ aws_security_group.sgforec2.id ]
    }
    tag_specifications {
      resource_type = "instance"
      tags = {
      Name = "ec2-web-server"
    }
    }
}


