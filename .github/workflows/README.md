# GitHub Actions Terraform workflow setup

This repository now includes a single consolidated workflow file:

- `terraform.yml`: handles feature-branch validation, manual apply from `main`, scheduled drift detection, and Slack notifications in one pipeline.

## Required repository secrets and variables

### Repository secrets
- `AWS_ROLE_TO_ASSUME`: the ARN of the GitHub OIDC role you want to use for AWS access.
- `SLACK_WEBHOOK_URL`: the Slack Incoming Webhook URL for notifications.
- `TF_VAR_JWT_SECRET`
- `TF_VAR_GOOGLE_CLIENT_SECRET`
- `TF_VAR_FB_CLIENT_SECRET`
- `TF_VAR_APPLE_PRIVATE_KEY`
- `TF_VAR_ADMIN_SECRET_KEY`
- `TF_VAR_ADMIN_PASSWORD`

### Repository variables
- `AWS_REGION` (optional, defaults to `us-east-1`)

## Important notes

1. The apply workflow is intentionally manual-only. It runs only from `workflow_dispatch` after you merge to `main`, and it expects the user to type `APPLY` in the workflow input.
2. The drift workflow only detects drift; it does not auto-remediate.
3. This workflow assumes the Terraform backend is already configured in `backend.tf` and that the OIDC role has access to your S3 state bucket and DynamoDB lock table.
4. For a stronger approval gate, configure a GitHub environment named `production` with required reviewers. The workflow already declares that environment.
