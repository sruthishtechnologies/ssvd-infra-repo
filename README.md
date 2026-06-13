# SSVD Infra Repo

Terraform infrastructure for SSVD AWS environments.

This repo provisions:

- Low-cost AWS VPC per environment
- EKS cluster per environment
- Managed EKS node group
- ECR repository for `ssvd-bhoomi-report`
- Argo CD installed into each EKS cluster
- Argo CD root app that watches `sruthishtechnologies/ssvd-ops-repo`
- Optional GitHub Actions OIDC IAM role

## Repository Layout

```text
modules/
  network/        VPC, internet gateway, public subnets, routes
  eks/            EKS cluster, managed node group, core add-ons
  ecr/            ECR repositories and lifecycle policies
  argocd/         Argo CD Helm install and root app
  github-oidc/    Optional GitHub Actions IAM role
envs/
  dev/            Dev environment
  staging/        Staging environment
  prod/           Production environment
policies/
  conftest/       OPA policies for Terraform guardrails
.github/
  workflows/      Validation, cost, security, and apply workflows
```

## Low-Cost Demo Defaults

The committed defaults are intentionally small:

- Region: `ap-south-2`
- One EKS managed node group per environment
- `t3.small` node type
- Desired nodes: `1`
- No NAT gateway
- Public subnets for demo cost control
- Argo CD server service type: `ClusterIP`
- ECR lifecycle keeps the latest 20 images

EKS itself has an hourly cluster control-plane cost. Destroy demo environments
when they are not needed.

## Environment Flow

Each environment has its own EKS cluster and Argo CD instance:

```text
envs/dev Terraform apply
  -> creates ssvd-dev-eks
  -> installs Argo CD
  -> Argo CD loads bootstrap/dev from ssvd-ops-repo
  -> bootstrap/dev/root.yaml loads envs/dev/apps from ssvd-ops-repo
  -> app manifests render Helm chart + dev values
```

The same pattern applies to staging and prod.

## First Deploy

Use an AWS identity with permission to create VPC, IAM, ECR, EKS, and related
resources.

```bash
cd envs/dev
terraform init -backend=false
terraform plan
terraform apply
```

For a production team setup, copy `backend.tf.example` to `backend.tf` in each
environment and use an encrypted S3 backend with DynamoDB locking.

## GitHub Configuration

Repository variables:

- `AWS_REGION`: for example `ap-south-2`
- `AWS_ROLE_TO_ASSUME`: IAM role ARN used by plan/apply workflows
- `TF_STATE_BUCKET`: S3 bucket used for Terraform remote state
- `TF_LOCK_TABLE`: optional DynamoDB table used for Terraform state locking

Repository secrets:

- `INFRACOST_API_KEY`: enables Infracost PR comments
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`: fallback only if OIDC is not configured

The `Terraform Apply` workflow runs after changes merge to `main`. It applies
only environments whose files changed. Changes under `modules/` apply all
environments because shared modules can affect every cluster.

Use GitHub environment protection rules for `dev`, `staging`, and `prod` if you
want an additional approval gate after merge and before Terraform apply.

## CI Controls

The repo includes:

- Terraform fmt/init/validate
- Optional Terraform plan
- Infracost
- OPA/conftest
- Checkov
- Gitleaks
- Dependabot

`terraform-plan` and `infracost` skip gracefully until the required AWS and
Infracost credentials are configured.

## Production Hardening Follow-Ups

The demo baseline minimizes cost. For stricter production compliance, add:

- Private subnets and NAT or VPC endpoints
- EKS private endpoint only
- Customer-managed KMS keys
- AWS Load Balancer Controller with IRSA
- External Secrets Operator
- Cluster Autoscaler or Karpenter
- Centralized logging and monitoring
- Separate AWS accounts for dev, staging, and prod
