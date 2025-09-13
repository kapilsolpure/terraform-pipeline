variable "ami" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
  # default   = "ami-0abcdef1234567890"  # optional, set your default AMI here
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
