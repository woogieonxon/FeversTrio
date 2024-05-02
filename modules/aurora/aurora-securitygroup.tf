resource "aws_security_group" "aurora_sg" {
  name   = "aurora-sg"
  vpc_id = var.vpc_id

  # 인바운드 규칙: 특정 IP 범위에서 Aurora DB로의 MySQL/Aurora 접속 허용
  ingress {
    description = "MySQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 여기에 허용하려는 CIDR 블록을 지정하세요
  }

#   # 인바운드 규칙: 특정 보안 그룹에서의 접근 허용 (예: 다른 EC2 인스턴스)
#   ingress {
#     description = "Intra-VPC access"
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     security_groups = [aws_security_group.other_sg.id]  # 다른 보안 그룹의 ID
#   }

  # 아웃바운드 규칙: 인터넷으로의 모든 트래픽 허용
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # '-1'은 모든 프로토콜을 의미함
    cidr_blocks = ["0.0.0.0/0"]
  }
}
