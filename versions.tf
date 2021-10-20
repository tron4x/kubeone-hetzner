terraform {
  required_version = ">= 0.15.1"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.26.0"
    }
  }
}
