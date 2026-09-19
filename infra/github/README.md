# GitHub Terraform

This stack manages the GitHub configuration for `remembeer-app/remembeer`:

- repository features and merge settings
- the `main` and `convex` repository rulesets
- GitHub Actions and workflow token permissions
- Dependabot vulnerability alerts and security updates
- issue labels

The stack intentionally does not manage collaborators or Actions secrets.
Files under `.github` remain normal source-controlled files.

## HCP Terraform

HCP Terraform runs plans and applies from the `remembeer-app-repo` workspace:

- VCS repository: `remembeer-app/remembeer`, branch `main`
- Working directory: `infra/github`
- Execution mode: remote
- Terraform version: `1.16.3`

The workspace has a sensitive `GITHUB_TOKEN` environment variable containing a
fine-grained token scoped to this repository with **Administration: write** and
**Issues: write** permissions.

## Local commands

Plans and applies belong to the HCP Terraform workspace. Local commands only
format and validate the configuration:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```
