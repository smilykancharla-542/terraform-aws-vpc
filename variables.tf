variable "vpc_cidr" {
    type = string
    description = "please provide vpc cidr"
}
variable "project_name" {
    type = string
    description = "please provide project name"
}
variable "environment"{
    type = string
    description = "provide environment"
}
variable "vpc_tags" {
    type = map
    default ={}
    description = "you can provide ur custom tags"
  
}

variable "igw_tags" {
    type = map
    default ={}
    description = "you can provide ur custom tags"
  
}
variable "public_cidr_blocks"{
    type =list 
    description = "provide cidr value"
}
variable "subnet_tags"{
    type=map 
    default = {}
    description = "provide subnet tags"
}
variable private_cidrs{
    type=list 
    description = "provide private subnet cidr"
}
variable database_cidrs{
    type=list 
    description = "provide private subnet cidr"
}

variable "route_table_tags" {
    type = map 
    default = {}
    description = "provide ur routetable tags"
  
}
variable "eip_tags" {
    type = map 
    default = {}
    description = "provide ur routetable tags"
  
}
variable "is_peering_reuired"{
    type =bool 
    default = true
}