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
