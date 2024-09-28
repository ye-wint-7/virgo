variable "public_cidr_block" {
  type = list(string)
}

variable "private_cidr_block" {
  type = list(string)
}

variable "db_cidr_block" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "prefix" {
  type = string
}