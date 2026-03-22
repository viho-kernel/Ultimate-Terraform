#Terraform Block
terraform {
  #Required Terraform Version
  required_version = "~> 1.13.4"
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
  region = "us-east-2"
}

#Resource Block
resource "aws_instance" "main" {
  ami           = "ami-0b0b78dcacbab728f"
  instance_type = "t3.micro"
}
