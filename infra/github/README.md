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

## HCP Terraform workspace

The stack runs from the `remembeer-app-repo` workspace with this configuration:

- VCS repository: `remembeer-app/remembeer`
- VCS branch: `main`
- Terraform working directory: `infra/github`
- Execution mode: **Remote**
- Terraform version: `1.16.3`
- Auto-apply API, UI, and VCS runs: enabled
- Auto-apply run triggers: disabled
- Automatic speculative plans: enabled by default

The GitHub App connection lets HCP Terraform read the repository, but it does
not authenticate the GitHub Terraform provider. The `GITHUB_TOKEN` environment
variable provides that separate authentication. It is configured as a
sensitive workspace environment variable and contains a fine-grained token
scoped to this repository with **Administration: write** and **Issues: write**
permissions.

## First run

After this configuration reaches `main`, manually queue **New run > Plan and
apply** once. A new VCS workspace does not process repository webhooks until it
has completed an initial run.

The first apply uses the import blocks in `imports.tf` to adopt the existing
GitHub resources. The expected initial plan is 16 imports with no additions,
changes, or deletions. Subsequent applies treat the imports as no-ops and are
started automatically by changes under `infra/github`.

## Local commands

Local commands only format and validate the configuration. Plans and applies
belong to the HCP Terraform VCS workspace.

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```
