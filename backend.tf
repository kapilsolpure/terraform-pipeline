terraform {
  backend "s3" {
    #bucket = "kapil-terraformstatefile-bucket-1234567810"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}

