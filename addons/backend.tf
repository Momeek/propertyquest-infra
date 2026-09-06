terraform {
  backend "s3" {
    bucket         = "propertyquest-gitops-terraformstate"
    key            = "propertyquest/eks/addons/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "propertyquest-terraform-locks"
    encrypt        = true
    use_lockfile   = true
  }
}
