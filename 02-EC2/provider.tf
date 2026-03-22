#Terraform Block
terraform {
  #Required Terraform Version
  required_version = "~> 1.14.5"
  #Required providers and their version
  required_providers {
    aws = { #Localname must be unique per-module.
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

#Provider Block
provider "aws" {
  region = var.region
}
