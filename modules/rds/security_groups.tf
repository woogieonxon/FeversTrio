# RDS 인스턴스를 위한 보안 그룹 생성

resource "aws_security_group" "rds" {
  name        = "${var.db_name}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

# 인바운드 규칙: MySQL 기본 포트인 3306에서 베스천 호스트의 보안 그룹으로부터의 접근만 허용
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.bastion_security_group_id] // 베스천 호스트 SG만 허용
  }

# 아웃바운드 규칙: 모든 대역폭으로부터의 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-rds-sg"
  }
}
