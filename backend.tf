terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-12345678"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
