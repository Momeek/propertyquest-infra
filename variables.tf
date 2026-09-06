variable "region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "propertyquest-eks-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the EKS VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used by the VPC."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two availability zones are required."
  }
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group."
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_min_size" {
  description = "Minimum number of EKS nodes."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of EKS nodes."
  type        = number
  default     = 4
}

variable "node_desired_size" {
  description = "Desired number of EKS nodes."
  type        = number
  default     = 3
}

variable "db_name" {
  description = "RDS database name."
  type        = string
  default     = "propertyquest"
}

variable "db_username" {
  description = "RDS application username."
  type        = string
  default     = "propertyquest_app"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.small"
}

variable "db_allocated_storage" {
  description = "RDS storage size in GiB."
  type        = number
  default     = 20
}

variable "jwt_secret" {
  description = "Application JWT secret."
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth client secret."
  type        = string
  sensitive   = true
}

variable "fb_client_secret" {
  description = "Facebook OAuth client secret."
  type        = string
  sensitive   = true
}

variable "apple_private_key" {
  description = "Apple private key."
  type        = string
  sensitive   = true
}

variable "admin_secret_key" {
  description = "Application admin secret key."
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Application admin password."
  type        = string
  sensitive   = true
}
