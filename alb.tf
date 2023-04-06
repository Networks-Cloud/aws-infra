resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg"
  vpc_id      = aws_vpc.vishal.id
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load_balancer_security_group"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

resource "aws_lb" "lb" {

  name = "csye6225-lb"

  internal = false

  load_balancer_type = "application"
  # foreach = toset([for o in aws_subnet.public : o.id])
  # subnet_mapping {
  #   subnet_id = each.key
  # }

  security_groups = [aws_security_group.alb_sg.id]

  subnet_mapping {
    subnet_id = aws_subnet.public[1].id
  }

  subnet_mapping {
    subnet_id = aws_subnet.public[0].id
  }

  subnet_mapping {
    subnet_id = aws_subnet.public[2].id
  }

  enable_deletion_protection = false


  tags = {

    Application = "WebApp"

  }

}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

resource "aws_lb_target_group" "alb_tg" {

  name = "csye6225-lb-alb-tg"

  target_type = "instance"


  port     = 5000
  protocol = "HTTP"

  vpc_id = aws_vpc.vishal.id

  health_check {
    path="/healthz"
  }


}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

resource "aws_lb_listener" "front_end" {

  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.alb_tg.arn

  }

}
