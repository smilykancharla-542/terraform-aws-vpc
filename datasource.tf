data "aws_availability_zones" "available" {
  state = "available"
}

## retriveing default vpc details
data "aws_vpc" "default_vpc" {
  default = true
}
## default vpc route table
data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default_vpc.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}