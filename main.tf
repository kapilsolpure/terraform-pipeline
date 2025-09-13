# --------------------------------------
# Terraform Backend (in backend.tf file ideally)
# --------------------------------------
# This is managed outside Terraform (do NOT define the bucket as a resource)
terraform {
  backend "s3" {
    bucket = "kapil-terraformstatefile-bucket-12345678"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# --------------------------------------
# Get Default VPC
# --------------------------------------
data "aws_vpc" "default" {
  default = true
}

# --------------------------------------
# Get a Subnet from the Default VPC
# --------------------------------------
data "aws_subnet_ids" "default_subnets" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "default_subnet" {
  id = tolist(data.aws_subnet_ids.default_subnets.ids)[0]
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
  subnet_id              = data.aws_subnet.default_subnet.id
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
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}
