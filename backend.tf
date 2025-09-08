terraform {
  backend "s3" {
    bucket = "Kapil-terraform-state-bucket-123456"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
