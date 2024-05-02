# 베스천 호스트 EC2 인스턴스 설정
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.woogie_ec2_instance_my_profile.name
  associate_public_ip_address = true

  root_block_device {
      volume_size = var.root_volume_size
    }

  tags = {
    Name = "bastion"
  }
}

# 베스천 호스트 EC2 인스턴스를 위한 IAM 역할
resource "aws_iam_role" "woogie_iam_role_ec2_instance_bastion" {
  name = "woogie-iam-role-ec2-instance-bastion"

  assume_role_policy = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": {
            "Federated": "arn:aws:iam::194453983284:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/1C8D64F4169A65D07D4CEE7CA7081AF2"
         },
         "Action": "sts:AssumeRoleWithWebIdentity",
         "Condition": {
            "StringEquals": {
               "oidc.eks.ap-northeast-2.amazonaws.com/id/1C8D64F4169A65D07D4CEE7CA7081AF2:aud": "sts.amazonaws.com",
               "oidc.eks.ap-northeast-2.amazonaws.com/id/1C8D64F4169A65D07D4CEE7CA7081AF2:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
            }
         }
      }
   ]
}
POLICY

  tags = {
    Name = "woogie-iam-role-ec2-instance-bastion"
  }
}

# 베스천 호스트 EC2 인스턴스를 위한 IAM 인스턴스 프로파일
resource "aws_iam_instance_profile" "woogie_ec2_instance_my_profile" {
  name = "woogie-ec2-instance-my-profile"
  role = aws_iam_role.woogie_iam_role_ec2_instance_bastion.name
}


# 베스천 호스트 EC2 인스턴스를 위한 보안그룹
resource "aws_security_group" "bastion_sg" {
  name        = "${var.name}-sg"
  description = "Security group for bastion host"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

