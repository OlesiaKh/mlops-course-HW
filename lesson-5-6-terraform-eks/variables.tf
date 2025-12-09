variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "tf-ml-user"
}

variable "project_name" {
  description = "Base project name"
  type        = string
  default     = "mlops-eks"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}
