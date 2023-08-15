# module "eks" {
#   source          = "terraform-aws-modules/eks/aws"
#   version         = "19.14.0"
#   cluster_name    = "adonce-terraform"
#   cluster_version = "1.27"

#   # cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   enable_irsa = true

#   eks_managed_node_group_defaults = {
#     disk_size = 50
#   }
#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#   }

#   eks_managed_node_groups = {
#     general = {
#       desired_size = 2
#       min_size     = 2
#       max_size     = 2

#       labels = {
#         role = "general"
#       }

#       instance_types = ["t2.large"]
#       capacity_type  = "ON_DEMAND"
#     }
#   }

#   tags = {
#     Environment = "staging"
#   }

# }


# # # https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
# data "aws_iam_policy" "ebs_csi_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }

# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version = "4.7.0"

#   create_role                   = true
#   role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
#   provider_url                  = module.eks.oidc_provider
#   role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
# }

# resource "aws_eks_addon" "ebs-csi" {
#   cluster_name             = module.eks.cluster_name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.18.0-eksbuild.1"
#   service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#   tags = {
#     "eks_addon" = "ebs-csi"
#     "terraform" = "true"
#   }
# }

# # -----------------#
# # AWS ELB.         #
# # -----------------#

# data "aws_eks_cluster" "adonce-terraform" {
#   name = module.eks.cluster_name
# }
# data "aws_eks_cluster_auth" "adonce-terraform" {
#   name = module.eks.cluster_name
# }


# module "aws_load_balancer_controller_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.1"

#   role_name = "aws-load-balancer-controller"

#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }

# resource "helm_release" "aws_load_balancer_controller" {
#   name = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.4.4"

#   set {
#     name  = "replicaCount"
#     value = 1
#   }

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.aws_load_balancer_controller_irsa_role.iam_role_arn
#   }
# }