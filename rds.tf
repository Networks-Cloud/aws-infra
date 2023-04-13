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

resource "aws_db_parameter_group" "example" {
  family = "mysql8.0"
}

resource "aws_db_instance" "mydb" {
  allocated_storage      = 10
  db_name                = "webapp"
  engine                 = "mysql"
  engine_version         = "8.0.26"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]
  db_subnet_group_name   = aws_db_subnet_group.example.id
  parameter_group_name   = aws_db_parameter_group.example.name
  multi_az               = false
  kms_key_id = aws_kms_key.rds_key.arn
  storage_encrypted = true
  tags = {
    "Name" = "CSYE-6225"
  }
}
