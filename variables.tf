variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "cluster_name" {
  type        = string
  default     = "<name of cluster>"
  description = "The name of the cluster"
}

variable "aws_region" {
  type        = string
  default     = "<Region>"
  description = "AWS region where services are stored."
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  default     = "<OIDC issuer>"
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  default     = "<OIDC arn>"
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "helm_services" {
  type = list(object({
    name       = string
    policy_arn = string
    settings   = map(any)
  }))
  default = [
    {
      name       = "ecr"
      policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
      settings   = {}
    }
  ]
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "ack-system"
  description = "Kubernetes namespace to deploy ACK Helm chart."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}
