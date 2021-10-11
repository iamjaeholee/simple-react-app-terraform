/**
  * configure the provider
  */

provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-2"
}

provider "kubernetes" {}