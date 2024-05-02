resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-db"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.06.0"
  database_name           = var.db_name
  master_username         = var.db_user
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]

  skip_final_snapshot     = true
}




resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = var.subnet_ids
}



# Optionally define instances within the cluster
resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 1
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.db_instance_class
  engine                  = "aurora-mysql"
}
