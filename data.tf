# Copyright 2019 M.Holger / Parallel Theory LLC - All rights reserved

data "aws_ami" "consul" {
  most_recent = true
  owners      = ["158475542264"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["false"]
  }

  filter {
    name   = "name"
    values = ["Consul/Vault Master *"]
  }
}

