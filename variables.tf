variable "region" {
  default = "up-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-0a232144cf20a27a5"  # Update based on your region
}

