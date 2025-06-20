terraform {
  required_providers {
    aws = {
      version = "= 5.52.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-statefile-particle41"   # Must exist already
    key            = "eks/particle/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"               # Must exist already
    encrypt        = true
  }
}