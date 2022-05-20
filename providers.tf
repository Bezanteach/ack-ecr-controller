
terraform {
  required_version = "~> 1.1.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.5.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.4.0"
    }
  }
}

provider "aws" {
  region   = var.aws_region
}

provider "kubernetes" {
  config_path            = "~/.kube/config"
  token                  = data.aws_eks_cluster_auth.ack.token
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.ack.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.ack.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}



