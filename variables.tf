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