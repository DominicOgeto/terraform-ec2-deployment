terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket1456"
    key          = "test/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
