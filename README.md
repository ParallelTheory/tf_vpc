VPC
===

Introduction
------------

This module creates a VPC structure, with a set of private subnets in listed availability zones, routing through a NAT gateway/public subnet for external connectivity. Additionally, will setup AWS VPC peering with specified targets.


Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_name | Name of associated project, for resource tagging | string | `...` | yes |
| project\_workspace | Name of associated terraform workspace, for tagging | string | `...` | yes |
| vpc\_cidr | CIDR block for new VPC | string | `"10.0.0.0/16"` | no |
| subnets | List of private subnets to create within new VPC | list | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` | no |
| subnet_az | List of availability zones, one per subnet | list | `["us-east-1a", "us-east-1b", "us-east-1c"]` | no |
| public_cidr | CIDR block for "public" subnet to house Internet gateway | string | `"10.0.254.0/24"` | no |
| peer_vpc_cidrs | List of VPC CIDR blocks with which to establish peering | list | nil | no |
| peer_vpc_ids | List of VPC resource IDs with which to establish peering | list | nil | no |
| peer_vpc_regions | List of regions within which peer VPCs exist | list | nil | no |


Outputs
-------
| Name | Description | Type |
|------|-------------|:----:|
| vpc\_id | AWS resource ID of new VPC | string |
| vpc\_arn | AWS ARN of new VPC | string |
| subnet\_id | List of new private subnet IDs | list |
| subnet\_arn | List of new private subnet ARNs | list |
| public\_subnet\_id | Resource ID of new public subet |
| public\_subnet\_arn | AWS ARN of new public subnet |


Example
-------
```
provider "aws" {
  region = "us-east-1"
  version = "~> 2.31.0"
}

module "aws_vpc" {
  source            = "ParallelTheory/tf_vpc"
  version           = "0.0.1"

  project_name      = "example_vpc"
  project_workspace = "dev"
  vpc_cidr          = "10.0.0.0/16"
  subnets           = ["10.0.1.0/24"]
  subnet_az         = ["us-east-1c"]
  public_cidr       = "10.0.254.0/28"
}
```


Authors
-------

_Copyright 2019 M. Holger / Parallel Theory LLC, All Rights Reserved_


License
-------

_TBD_