variable "project_name" {
  description = "Name used for AWS resources"
  type        = string
  default     = "odoo20-demo"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "availability_zones" {
  description = "Availability Zones for the public subnets"
  type        = list(string)

  default = [
    "eu-north-1a",
    "eu-north-1b"
  ]
}


variable "ec2_instance_type" {
  description = "EC2 instance type for the k3s node"
  type        = string
  default     = "t3.micro"
}

variable "ec2_root_volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 30
}

variable "ec2_data_volume_size" {
  description = "Separate EBS data volume size in GiB"
  type        = number
  default     = 100
}