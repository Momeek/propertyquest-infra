terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.19.2"
  wait             = true

  set = [{
    name  = "serviceAccount.create"
    value = "true"
    }, {
    name  = "serviceAccount.name"
    value = "external-secrets"
  }]
}

resource "aws_eks_pod_identity_association" "external_secrets" {
  cluster_name    = var.cluster_name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = var.external_secrets_role_arn

  depends_on = [helm_release.external_secrets]
}

resource "kubernetes_manifest" "secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "SecretStore"
    metadata = {
      name      = "aws-secretsmanager"
      namespace = "default"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.region
        }
      }
    }
  }

  depends_on = [aws_eks_pod_identity_association.external_secrets]
}

resource "kubernetes_manifest" "propertyquest_secret" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"
    metadata = {
      name      = "propertyquest-secret"
      namespace = "default"
    }
    spec = {
      refreshInterval = "1h"
      secretStoreRef = {
        name = "aws-secretsmanager"
        kind = "SecretStore"
      }
      target = {
        name           = "propertyquest-secret"
        creationPolicy = "Owner"
      }
      data = [
        {
          secretKey = "db-password"
          remoteRef = { key = var.secret_name, property = "DB_PASS" }
        },
        {
          secretKey = "jwt_secret"
          remoteRef = { key = var.secret_name, property = "JWT_SECRET" }
        },
        {
          secretKey = "google_client_secret"
          remoteRef = { key = var.secret_name, property = "GOOGLE_CLIENT_SECRET" }
        },
        {
          secretKey = "fb_client_secret"
          remoteRef = { key = var.secret_name, property = "FB_CLIENT_SECRET" }
        },
        {
          secretKey = "apple_private_key"
          remoteRef = { key = var.secret_name, property = "APPLE_PRIVATE_KEY" }
        },
        {
          secretKey = "admin_secret_key"
          remoteRef = { key = var.secret_name, property = "ADMIN_SECRET_KEY" }
        },
        {
          secretKey = "admin_password"
          remoteRef = { key = var.secret_name, property = "ADMIN_PASSWORD" }
        }
      ]
    }
  }

  depends_on = [kubernetes_manifest.secret_store]
}
