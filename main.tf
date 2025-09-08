resource "aws_s3_bucket" "tf_state" {
  bucket = "kapil-terraformstatefile-bucket-12345678"
  
  versioning {
    enabled = true
  }

  tags = {
    Name        = "Terraform State"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "web_sg" {
  # (your security group code remains the same)
}

resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello Technogees this is the Terraform Jenkins pipeline</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "TerraformWebServer"
  }
}

