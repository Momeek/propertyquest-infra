output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.this.arn
}

output "rds_endpoint" {
  description = "RDS endpoint, also written to Secrets Manager."
  value       = aws_db_instance.this.endpoint
}

output "propertyquest_secret_arn" {
  description = "ARN of the PropertyQuest Secrets Manager secret."
  value       = aws_secretsmanager_secret.propertyquest.arn
}

output "external_secrets_role_arn" {
  description = "IAM role ARN for External Secrets Operator Pod Identity."
  value       = aws_iam_role.external_secrets.arn
}
