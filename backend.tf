terraform {
  backend "s3" {
    bucket = "yurii-terraform-remotestate"
    key = "terraform.tfstate"
    region = "eu-central-1"
    profile = "terraform-admin"
    dynamodb_table = "terraformstate.lock"
  }
}