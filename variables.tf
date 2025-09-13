variable "ami" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-01f2711b72e050dbe"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
