locals {
  labels = {
    UI = {
      color       = "dcc312"
      description = ""
    }
    bug = {
      color       = "d73a4a"
      description = "Something isn't working"
    }
    dart = {
      color       = "000000"
      description = "Pull requests that update dart code"
    }
    dependencies = {
      color       = "0366d6"
      description = "Pull requests that update a dependency file"
    }
    documentation = {
      color       = "0075ca"
      description = "Improvements or additions to documentation"
    }
    enhancement = {
      color       = "a2eeef"
      description = "New feature or request"
    }
    github_actions = {
      color       = "000000"
      description = "Pull requests that update GitHub Actions code"
    }
    javascript = {
      color       = "168700"
      description = "Pull requests that update javascript code"
    }
    question = {
      color       = "d876e3"
      description = "Further information is requested"
    }
    refactor = {
      color       = "9c12dd"
      description = "Code changes that don't affect functionality."
    }
  }
}

resource "github_repository" "remembeer" {
  name         = "remembeer"
  description  = "Mobile application for logging consumed pints of beer."
  visibility   = "public"
  homepage_url = ""

  has_discussions = false
  has_issues      = true
  has_projects    = true
  has_wiki        = true
  is_template     = false

  allow_auto_merge       = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_update_branch    = false
  delete_branch_on_merge = true

  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  web_commit_signoff_required = false

  security_and_analysis {
    secret_scanning {
      status = "disabled"
    }
    secret_scanning_push_protection {
      status = "disabled"
    }
  }
}

resource "github_repository_ruleset" "protect_main" {
  name        = "Protect main"
  repository  = github_repository.remembeer.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      exclude = []
      include = ["refs/heads/main"]
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      allowed_merge_methods             = ["rebase", "squash", "merge"]
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 1
      required_review_thread_resolution = false
    }

    required_status_checks {
      strict_required_status_checks_policy = false
      do_not_enforce_on_create             = false

      required_check {
        context        = "Ready to merge"
        integration_id = 15368
      }
    }
  }
}

resource "github_repository_ruleset" "protect_convex" {
  name        = "Protect convex"
  repository  = github_repository.remembeer.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      exclude = []
      include = ["refs/heads/convex"]
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      allowed_merge_methods             = ["rebase", "squash", "merge"]
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 0
      required_review_thread_resolution = false
    }

    required_status_checks {
      strict_required_status_checks_policy = false
      do_not_enforce_on_create             = false

      required_check {
        context        = "Ready to merge"
        integration_id = 15368
      }
    }
  }
}

resource "github_actions_repository_permissions" "remembeer" {
  repository           = github_repository.remembeer.name
  enabled              = true
  allowed_actions      = "all"
  sha_pinning_required = false
}

resource "github_workflow_repository_permissions" "remembeer" {
  repository                       = github_repository.remembeer.name
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = true
}

resource "github_repository_vulnerability_alerts" "remembeer" {
  repository = github_repository.remembeer.name
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "remembeer" {
  repository = github_repository.remembeer.name
  enabled    = true
}

resource "github_issue_label" "this" {
  for_each = local.labels

  repository  = github_repository.remembeer.name
  name        = each.key
  color       = each.value.color
  description = each.value.description
}
