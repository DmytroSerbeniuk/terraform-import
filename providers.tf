terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "eu-central-1"
  shared_config_files      = ["/Users/dima/.aws/config"]
  shared_credentials_files = ["/Users/dima/.aws/credentials"]
}
