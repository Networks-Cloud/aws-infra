variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

resource "aws_security_group" "rds-security-group" {
  name_prefix = "my-security-group"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-security-group.id]
  }

  vpc_id = aws_vpc.vishal.id
  tags = {
    "Name" = "RDS Security Group"
  }
}

resource "aws_db_subnet_group" "example" {
  name = "main"

  subnet_ids = [for o in aws_subnet.private_subnet : o.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage = 10
  db_name           = "webapp"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  username          = var.db_username
  password          = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]
  db_subnet_group_name   = aws_db_subnet_group.example.id
  multi_az               = false
  tags = {
    "Name" = "CSYE-6225"
  }
}
