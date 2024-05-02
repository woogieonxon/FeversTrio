#
# module "iam_assumable_role_alb_controller" {
#   source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version                       = "5.0.0"
#   create_role                   = true
#   role_name                     = "${local.cluster_name}-alb-controller"
#   role_description              = "Used by AWS Load Balancer Controller for EKS"
#   provider_url                  = module.eks.cluster_oidc_issuer_url
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
# }
#
# data "http" "iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.1/docs/install/iam_policy.json"
# }
#
# resource "aws_iam_role_policy" "controller" {
#   name_prefix = "AWSLoadBalancerControllerIAMPolicy"
#   policy      = data.http.iam_policy.response_body
#   role        = module.iam_assumable_role_alb_controller.iam_role_name
# }
#
# data "aws_iam_policy_document" "additional_permissions" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:AddTags",
#     ]
#     resources = ["*"]
#   }
# }
#
# resource "aws_iam_policy" "additional_permissions" {
#   name        = "AdditionalPermissions"
#   description = "Additional permissions for AWS Load Balancer Controller"
#   policy      = data.aws_iam_policy_document.additional_permissions.json
# }
#
# resource "aws_iam_role_policy_attachment" "additional_permissions" {
#   role       = module.iam_assumable_role_alb_controller.iam_role_name
#   policy_arn = aws_iam_policy.additional_permissions.arn
# }
#
#
#
# ###########서비스 어카운트
# resource "kubernetes_service_account" "alb_controller" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
#     }
#   }
# }

module "iam_assumable_role_alb_controller" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.0.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-alb-controller"
  role_description              = "Used by AWS Load Balancer Controller for EKS"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}

data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.1/docs/install/iam_policy.json"
}

resource "aws_iam_role_policy" "controller" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  policy      = data.http.iam_policy.response_body
  role        = module.iam_assumable_role_alb_controller.iam_role_name
}

data "aws_iam_policy_document" "additional_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:AddTags",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "additional_permissions" {
  name        = "AdditionalPermissions"
  description = "Additional permissions for AWS Load Balancer Controller"
  policy      = data.aws_iam_policy_document.additional_permissions.json
}

resource "aws_iam_role_policy_attachment" "additional_permissions" {
  role       = module.iam_assumable_role_alb_controller.iam_role_name
  policy_arn = aws_iam_policy.additional_permissions.arn
}