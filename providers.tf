provider "aws" {
  region = var.region
  profile = "terraform-admin"

  default_tags {
    tags = {
    "Environmrnt" = var.environment
  }
}
}