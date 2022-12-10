data "aws_region" "current" {}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}