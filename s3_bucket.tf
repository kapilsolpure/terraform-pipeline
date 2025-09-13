#resource "aws_s3_bucket" "tf_state" {
  #bucket = "kapil-terraformstatefile-bucket-1234567810"
  #acl    = "private"

  #versioning {
    #enabled = true
  }

  #tags = {
   # Name = "TerraformStateBucket"
  }
}

#resource "aws_s3_bucket_public_access_block" "block" {
 # bucket = aws_s3_bucket.tf_state.id

  #block_public_acls       = true
  #block_public_policy     = true
  #ignore_public_acls      = true
  #restrict_public_buckets = true
}
