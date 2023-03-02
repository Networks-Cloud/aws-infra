variable "ami_name" {
  type = string
}

resource "aws_security_group" "my-security-group" {
  name_prefix = "my-security-group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vishal.id
  tags = {
    "Name" = "application"
  }
}

resource "aws_instance" "my-ec2-instance" {
  ami           = var.ami_name
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my-security-group.id]
  subnet_id = aws_subnet.public[0].id
  key_name      = "ec2"
  security_groups = [
    aws_security_group.my-security-group.id
  ]
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name = "My EC2 Instance"
  }
}