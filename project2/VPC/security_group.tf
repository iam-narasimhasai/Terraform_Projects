resource "aws_security_group" "ALBsg" {
  name   = "ALB Securitygroup"
  vpc_id = aws_vpc.vpc1.id
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sshsg" {
  name   = "sshsg"
  vpc_id = aws_vpc.vpc1.id
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]

  }
  
}

resource "aws_security_group" "webserversg" {
  name = "webserversg"
  vpc_id = aws_vpc.vpc1.id
  ingress {
     from_port   = 80
    to_port     = 80
    protocol = "tcp"
    security_groups = [aws_security_group.ALBsg.id]
  }
  ingress {
     from_port   = 22
    to_port     = 22
    protocol = "tcp"
    security_groups = [aws_security_group.sshsg.id]

  }
  ingress {
     from_port   = 443
    to_port     = 443
    protocol = "tcp"
    security_groups = [aws_security_group.ALBsg.id]
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.vpc1.id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.webserversg.id]
  }
}