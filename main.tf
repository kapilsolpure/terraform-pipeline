
# --------------------------------------
# S3 Bucket for Terraform State
# --------------------------------------
resource "aws_s3_bucket" "tf_state" {
  bucket = "kapil-terraformstatefile-bucket-12345678"  # Your bucket name

  tags = {
    Name        = "Terraform State"
    Environment = "Dev"
  }
} 

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
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

# --------------------------------------
# Get Default VPC (optional, you can remove if unused)
# --------------------------------------
data "aws_vpc" "default" {
  default = true
}

# --------------------------------------
# Security Group for EC2 Instance
# --------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# --------------------------------------
# EC2 Instance
# --------------------------------------
resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = "subnet-0c3ca3156cd7de127"  # Your subnet ID
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello Technogees, this is the Terraform Jenkins pipeline</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "TerraformWebServer"
  }
}

# --------------------------------------
# Outputs
# --------------------------------------
#output "instance_public_ip" {
  #description = "Public IP of the EC2 instance"
  #value       = aws_instance.web.public_ip
#}

