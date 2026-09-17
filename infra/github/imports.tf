import {
  to = github_repository.remembeer
  id = "remembeer"
}

import {
  to = github_repository_ruleset.protect_main
  id = "remembeer:9086050"
}

import {
  to = github_actions_repository_permissions.remembeer
  id = "remembeer"
}

import {
  to = github_workflow_repository_permissions.remembeer
  id = "remembeer"
}

import {
  to = github_repository_vulnerability_alerts.remembeer
  id = "remembeer"
}

import {
  to = github_repository_dependabot_security_updates.remembeer
  id = "remembeer"
}

import {
  for_each = local.labels

  to = github_issue_label.this[each.key]
  id = "remembeer:${each.key}"
}
