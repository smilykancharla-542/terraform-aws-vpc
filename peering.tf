resource "aws_vpc_peering_connection" "default" {
  count= var.is_peering_reuired ? 1 :0  # since peering is optional 
  peer_vpc_id   = data.aws_vpc.default_vpc.id  ##accepter
  vpc_id        = aws_vpc.main.id ##reciever

  auto_accept   = true  # if vpc are from different accounts it won't work

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }


  tags = merge(
    var.vpc_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-default"
    }
  )
}

resource "aws_route" "public_peering" {
    count= var.is_peering_reuired ? 1 :0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "default_peering" {
    count= var.is_peering_reuired ? 1 :0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}