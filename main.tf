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

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.igw_tags,
    local.common_tags,{
        Name =local.common_name_suffix
    }
  )
}