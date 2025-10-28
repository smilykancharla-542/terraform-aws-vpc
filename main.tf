##creating vpc
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames= true

  tags = merge(var.vpc_tags,
    local.common_tags,{
        Name =local.common_name_suffix
    }
  )
  
}
###creating internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.igw_tags,
    local.common_tags,{
        Name =local.common_name_suffix
    }
  )
}

##creating subnets

resource "aws_subnet" "public" {
  count=length(var.public_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_blocks[count.index]
  availability_zone=local.availability_zones[count.index]
  map_public_ip_on_launch= true

  tags = merge(var.subnet_tags,
    local.common_tags,{
        Name ="${local.common_name_suffix}-public-${local.availability_zones[count.index]}"  #roboshop-dev-public-subnet-us-east-1a
    }
  )
}

##creating subnets
resource "aws_subnet" "private" {
  count=length(var.private_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidrs[count.index]
  availability_zone=local.availability_zones[count.index]
  

  tags = merge(var.subnet_tags,
    local.common_tags,{
        Name ="${local.common_name_suffix}-private${local.availability_zones[count.index]}"  #roboshop-dev-private-us-east-1a
    }
  )
}
resource "aws_subnet" "database" {
  count=length(var.database_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidrs[count.index]
  availability_zone=local.availability_zones[count.index]
  

  tags = merge(var.subnet_tags,
    local.common_tags,{
        Name ="${local.common_name_suffix}-database-${local.availability_zones[count.index]}"  #roboshop-dev-database-us-east-1a
    }
  )
}

###creating route tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.route_table_tags,
    local.common_tags,{
        Name ="${local.common_name_suffix}-public"  #roboshop-dev-public
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.route_table_tags,
    local.common_tags,{
        Name ="${local.common_name_suffix}-private"  #roboshop-dev-public
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.route_table_tags,
    local.common_tags,{
        Name ="${local.common_name_suffix}-database"  #roboshop-dev-public
    }
  )
}
###allowing internet through internet gateway
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id=aws_internet_gateway.main.id
}

##creating elastic ip
resource "aws_eip" "nat" {
 domain   = "vpc"
 tags = merge(var.eip_tags,
    local.common_tags,{
        Name =local.common_name_suffix  ##roboshop-dev
    }
  )
}

##creating nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

##creating route for engress
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id=aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id=aws_nat_gateway.nat.id
}

##creating association between route table and subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count = length(var.private_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
  count = length(var.database_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}