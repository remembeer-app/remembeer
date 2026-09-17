# GitHub Terraform

This stack manages the declarative GitHub configuration for
`remembeer-app/remembeer`:

- repository features and merge settings
- the `main` repository ruleset
- GitHub Actions and workflow token permissions
- Dependabot vulnerability alerts and security updates
- issue labels

The stack intentionally does not manage collaborators or Actions secrets.
Workflow and Dependabot YAML files remain normal source-controlled files under
`.github`.

## HCP Terraform setup

1. Create an HCP Terraform organization and a workspace named
   `remembeer-app-repo`.
2. Set the workspace execution mode to **Local**. HCP Terraform stores state;
   GitHub Actions executes Terraform.
3. Create an HCP Terraform user or team API token with access to that workspace.
4. Add the repository variable `HCP_TERRAFORM_ORGANIZATION` containing the HCP
   Terraform organization name.
5. Add the repository secret `TF_API_TOKEN` containing the HCP Terraform token.
6. Add the repository secret `TERRAFORM_GITHUB_TOKEN` containing a fine-grained
   GitHub token scoped only to this repository. Grant it **Administration: write**
   and **Issues: write** permissions.

The first apply uses the import blocks in `imports.tf` to adopt the existing
GitHub resources. Subsequent applies treat those imports as no-ops.

## Local commands

Authenticate to HCP Terraform with `terraform login`, then export:

```bash
export TF_CLOUD_ORGANIZATION=<hcp-terraform-organization>
export GITHUB_TOKEN=<fine-grained-github-token>
```

Run Terraform from this directory:

```bash
terraform init
terraform plan
```
