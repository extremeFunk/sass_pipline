provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}
# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "http-8080" {
  name        = "http8080"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "http-80" {
  name        = "http80"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.environment_tag}"
  }
}

resource "aws_subnet" "AZ-b" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.0.0/25"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.environment_tag}"
  }
}

resource "aws_subnet" "AZ-a" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.0.128/25"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.environment_tag}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "${var.environment_tag}"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "${var.environment_tag}"
  }
}

resource "aws_route_table_association" "rta_a" {
  subnet_id      = "${aws_subnet.AZ-a.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_route_table_association" "rta_b" {
  subnet_id      = "${aws_subnet.AZ-b.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}
