terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  cloud {
    workspaces {
      name = "remembeer-app-repo"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }
}

provider "github" {
  owner = "remembeer-app"
}
