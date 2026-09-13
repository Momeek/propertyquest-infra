terraform {
  backend "s3" {
    bucket       = "propertyquest-gitops-terraformstate"
    key          = "propertyquest/eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
  }
}
