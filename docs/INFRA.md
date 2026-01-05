# Infrastructure Setup

This guide covers AWS and CI/CD infrastructure setup. For local development, see the [README](../README.md).

## Prerequisites

- [Terraform](https://terraform.io) - Infrastructure as code
- [AWS CLI](https://aws.amazon.com/cli/) - AWS command line
- [GitHub CLI](https://cli.github.com) - GitHub command line
- [Bun](https://bun.sh) - Required for GitHub App creation script

## Quick Start

Run the infrastructure setup script to validate dependencies and configure secrets:

```bash
./scripts/infra-setup.sh
```

The script will:

1. Check for required CLI tools
2. Validate AWS and GitHub authentication
3. Create the GitHub App if not configured
4. Guide you through setting any missing secrets

## Manual Setup

If you prefer to set things up manually:

### 1. AWS Profile

Configure an AWS profile named `able` in `~/.aws/credentials`:

```ini
[able]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
region = us-east-1
```

### 2. GitHub App

The GitHub App allows Terraform to manage repository settings (environments, branch protection, etc.) in CI.

The setup script handles this automatically, but if you need to create it manually:

1. Go to https://github.com/settings/apps/new
2. Fill in:
   - **Name**: `Able Terraform`
   - **Homepage URL**: `https://github.com/mpotter/able`
   - **Webhook**: Uncheck "Active"
3. Set permissions:
   - Administration: Read and write
   - Contents: Read-only
   - Environments: Read and write
   - Metadata: Read-only
   - Pull requests: Read and write
   - Actions: Read and write
4. Create the app
5. Install on the `able` repository
6. Generate a private key
7. Set secrets:
   ```bash
   gh secret set GH_APP_ID --body "YOUR_APP_ID"
   gh secret set GH_APP_PRIVATE_KEY < path/to/private-key.pem
   ```

### 3. Required Secrets

Set these in GitHub repository settings (Settings > Secrets and variables > Actions):

| Secret                     | Description                                                                                  |
| -------------------------- | -------------------------------------------------------------------------------------------- |
| `AWS_ROLE_ARN`             | IAM role ARN for GitHub Actions OIDC (e.g., `arn:aws:iam::ACCOUNT:role/able-github-actions`) |
| `TF_VAR_ANTHROPIC_API_KEY` | Anthropic API key for the application                                                        |
| `GH_APP_ID`                | GitHub App ID (created above)                                                                |
| `GH_APP_PRIVATE_KEY`       | GitHub App private key (PEM file contents)                                                   |

### 4. Optional Variables

Set these as GitHub variables (not secrets) for additional features:

| Variable      | Description                                    |
| ------------- | ---------------------------------------------- |
| `ALARM_EMAIL` | Email address for CloudWatch and Budget alerts |

## Infrastructure Deployment

After setup, infrastructure deploys automatically on push to `main`. To deploy manually:

```bash
# Deploy to dev
gh workflow run terraform.yml -f target=dev

# Deploy to prod
gh workflow run terraform.yml -f target=prod

# Deploy global resources
gh workflow run terraform.yml -f target=global
```

## Tear Down

To destroy all infrastructure:

```bash
# From local machine with AWS credentials
cd infra/terraform/environments/dev
AWS_PROFILE=able terraform destroy

cd ../prod
AWS_PROFILE=able terraform destroy

cd ../../global
AWS_PROFILE=able terraform destroy
```

**Warning**: This will delete all AWS resources including databases. Ensure you have backups if needed.
