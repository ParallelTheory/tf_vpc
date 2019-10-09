VPC
===

Introduction
------------

This module creates a VPC, with a set of private subnets in listed availability zones, routing through a NAT gateway/public subnet for external connectivity. Additionally, will setup AWS VPC peering with specified targets.


Inputs
------
* project_name
* project_workspace
* vpc_cidr
* subnets
* subnet_az
* public_Cidr
* peer_vpc_cidrs
* peer_vpc_ids
* peer_vpc_regions


Outputs
-------
* vpc_id
* vpc_arn
* subnet_id
* subnet_arn
* public_subnet_id
* public_subnet_arn


_Copyright 2019 M. Holger / Parallel Theory LLC, All Rights Reserved_
