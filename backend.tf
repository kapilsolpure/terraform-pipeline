terraform {
  backend "s3" {
    bucket = "kapil-terraformstatefile-bucket-12345678"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
