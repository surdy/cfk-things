variable "region" {
  description = "AWS region to provision the cluster"
  type        = string
  default     = "us-west-2"
}

variable "azs" {
  description = "Availability zones to deploy in within the region"
  type        = list
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the VPC to provision for the cluster"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets to prvision"
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnets to prvision"
  type        = list
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "EKS version to deploy"
  type        = string
}

variable "num_nodes" {
  description = "Number of nodes"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "EC2 instance type to use"
  type        = string
  default     = "m5.large"
}

variable "tags" {
  description = "Tags to add to the resources"
  type        = map
}

