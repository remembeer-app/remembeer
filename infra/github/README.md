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

Configure the `remembeer-app-repo` workspace as follows:

1. Connect the workspace to the `remembeer-app/remembeer` repository through
   the HCP Terraform GitHub App.
2. Set the Terraform working directory to `infra/github`.
3. Keep the execution mode set to **Remote**.
4. Select Terraform version `1.16.3`.
5. Enable automatic speculative plans for pull requests.
6. Enable auto-apply if changes merged to `main` should be applied without a
   manual confirmation in HCP Terraform.
7. Add a sensitive **environment variable** named `GITHUB_TOKEN`. Its value must
   be a fine-grained GitHub token scoped only to this repository with
   **Administration: write** and **Issues: write** permissions.

The GitHub App connection lets HCP Terraform read the repository, but it does
not authenticate the GitHub Terraform provider. The `GITHUB_TOKEN` environment
variable provides that separate authentication.

The first non-speculative apply uses the import blocks in `imports.tf` to adopt
the existing GitHub resources. Subsequent applies treat those imports as
no-ops.

## Local commands

Local commands only format and validate the configuration. Plans and applies
belong to the HCP Terraform VCS workspace.

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```
