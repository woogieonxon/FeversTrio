

resource "aws_iam_role" "eks_fargate_pod_role" {
  name = "AmazonEKSFargatePodExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        },
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_policy_attachment" {
  role       = aws_iam_role.eks_fargate_pod_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}


resource "aws_eks_fargate_profile" "example" {
  cluster_name           = module.eks.cluster_name
  fargate_profile_name   = "woogie-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod_role.arn
  subnet_ids             = var.private_subnets

  selector {
    namespace = "kube-system"
  }

}



