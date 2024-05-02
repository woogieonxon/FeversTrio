#새로운 유저 생성!
# locals {
#   tags = {
#     Environment = "test"
#     Terraform   = "true"
#   }
# }
#
# resource "aws_iam_user" "github-action" {
#   name = "github-action"
#   tags = local.tags
# }

# 원래 있던 기존 유저에 정책 연결해줌.
resource "aws_iam_user_policy" "github-action-pol" {
  name = "github-action-pol"
  user = "woogie"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPush",
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ],
            "Resource": "arn:aws:ecr:ap-northeast-2:${data.aws_caller_identity.current.account_id}:repository/bulletin"
        },
        {
            "Sid": "GetAuthorizationToken",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
