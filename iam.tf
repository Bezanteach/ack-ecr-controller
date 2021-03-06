# Role
data "aws_iam_policy_document" "kubernetes_ack_assume" {
  count = var.enabled ? length(var.helm_services) : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:ack-${var.helm_services[count.index].name}-controller",
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com",
      ]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "kubernetes_ack" {
  count              = var.enabled ? length(var.helm_services) : 0
  name               = "${var.cluster_name}-${var.helm_services[count.index].name}-ack"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_ack_assume[count.index].json
}

resource "aws_iam_role_policy_attachment" "kubernetes_ack" {
  count      = var.enabled ? length(var.helm_services) : 0
  role       = aws_iam_role.kubernetes_ack[count.index].name
  policy_arn = var.helm_services[count.index].policy_arn
}

data "aws_eks_cluster" "ack" {
  name = var.cluster_name
}


data "aws_eks_cluster_auth" "ack" {
  name = var.cluster_name
}

data "tls_certificate" "ack" {
  url = data.aws_eks_cluster.ack.identity[0].oidc[0].issuer
}

