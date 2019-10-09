# Copyright 2019 M.Holger / Parallel Theory LLC - All rights reserved

output "vpc_id" {
  value       = aws_vpc.primary_vpc.id
  description = "Newly Created VPC ID"
}

output "vpc_arn" {
  value       = aws_vpc.primary_vpc.arn
  description = "Newly Created VPC ARN"
}

output "subnet_id" {
  value       = aws_subnet.primary_subnet.*.id
  description = "List of new, private subnet IDs"
}

output "subnet_arn" {
  value       = aws_subnet.primary_subnet.*.arn
  description = "List of new, private subnet ARNs"
}

output "public_subnet_id" {
  value       = aws_subnet.public_subnet.id
  description = "Subnet ID for new, public subnet"
}

output "public_subnet_arn" {
  value       = aws_subnet.public_subnet.arn
  description = "Subnet ARN for new, public subnet"
}
