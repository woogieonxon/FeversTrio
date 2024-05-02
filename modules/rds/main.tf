# AWS RDS 인스턴스 생성
resource "aws_db_instance" "default" {
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  identifier              = var.identifier
  skip_final_snapshot     = true


  tags = var.tags
}


# RDS 인스턴스를 위한 서브넷 그룹 생성

resource "aws_db_subnet_group" "default" {
  name        = "${var.db_name}-subnet-group"
  subnet_ids  = var.subnet_ids

  tags = {
    "Name" = "${var.db_name}-subnet-group"
  }
}
