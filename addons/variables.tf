variable "region" {
  description = "AWS region for the EKS cluster."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Existing EKS cluster name."
  type        = string
  default     = "propertyquest-eks-cluster"
}

variable "secret_name" {
  description = "Existing AWS Secrets Manager secret name."
  type        = string
  default     = "propertyquest/application"
}

variable "external_secrets_role_arn" {
  description = "ARN of the IAM role created for External Secrets Operator Pod Identity."
  type        = string
}
