# Copyright 2019 M.Holger / Parallel Theory LLC - All rights reserved

resource "aws_vpc" "primary_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-primary_vpc"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_subnet" "primary_subnet" {
  count = length(var.subnets)

  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = element(var.subnets, count.index)
  availability_zone       = element(var.subnet_az, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-primary_subnet"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.primary_vpc.id
  cidr_block        = var.public_cidr
  availability_zone = element(var.subnet_az, 0)

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-public_subnet"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_security_group" "default_sg" {
  name        = "${var.project_name}-${var.project_workspace}-default_sg"
  description = "Default SG to allow traffic"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = concat(var.peer_vpc_cidrs, [var.public_cidr], [var.vpc_cidr])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-sg_peers"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_vpc_peering_connection" "vpc_peer" {
  count = length(var.peer_vpc_cidrs)

  vpc_id      = aws_vpc.primary_vpc.id
  peer_vpc_id = element(var.peer_vpc_ids, count.index)
  peer_region = element(var.peer_vpc_regions, count.index)
  auto_accept = false

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-${element(var.peer_vpc_ids, count.index)}-vpc_peer"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-nat_eip"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-igw"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-natgw"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_default_route_table" "public_routes" {
  default_route_table_id = aws_vpc.primary_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-public_routes"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_route_table" "nat_routes" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name      = "${var.project_name}-${var.project_workspace}-nat_routes"
    Project   = var.project_name
    Workspace = var.project_workspace
  }
}

resource "aws_route" "natgw_route" {
  route_table_id         = aws_route_table.nat_routes.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

resource "aws_route" "peer_route" {
  count = length(var.peer_vpc_ids)

  route_table_id            = aws_route_table.nat_routes.id
  destination_cidr_block    = element(var.peer_vpc_cidrs, count.index)
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer[0].id
}

resource "aws_route_table_association" "subnet_routes" {
  count = length(var.subnets)

  subnet_id      = element(aws_subnet.primary_subnet.*.id, count.index)
  route_table_id = aws_route_table.nat_routes.id
}

