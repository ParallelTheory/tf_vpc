# Copyright 2019 M.Holger / Parallel Theory LLC - All rights reserved

variable "project_name" {
  type        = string
  description = "Name of the project that this environement belongs to"
}

variable "project_workspace" {
  type        = string
  description = "Name of the workspace within the project that this environment belongs to"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Primary CIDR containing all subnet blocks"
}

variable "subnets" {
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "Subnet CIDR blocks"
}

variable "subnet_az" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "Availability zones for each newly created subnet; must be within aws_region"
}

variable "public_cidr" {
  default     = "10.0.254.0/24"
  description = "CIDR block to allocate to the public subnet"
}

variable "peer_vpc_cidrs" {
  default     = []
  description = "List of other VPC CIDR blocks to peer with"
}

variable "peer_vpc_ids" {
  default     = []
  description = "List of other VPC IDs to peer with"
}

variable "peer_vpc_regions" {
  default     = []
  description = "List of other VPC regions to peer with"
}

