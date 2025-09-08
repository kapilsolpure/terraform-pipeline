terraform {
  backend "s3" {
    bucket         = "kapil-terraformstatefile-bucket-12345678"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"              # ← Update if you're using a different region
    encrypt        = true
  }
}

