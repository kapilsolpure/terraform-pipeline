variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-0861f4e788f5069dd"  # Update based on your region
}

