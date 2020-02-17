# AWS Config
variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "ssh_key_path" {
  default         = ""
}

variable "ssh_key_name" {
  default         = ""
}

variable "aws_region" {
  default = ""
}

variable "phone" {
  default = ""
}

# Create a subnet to launch our instances into
variable "environment_tag" {
  default = ""
}

variable "ami" {
  default = "ami-00722eb4cc2201ab0"
}
variable "instance_type" {
  instance_type = "t2.micro"
}
