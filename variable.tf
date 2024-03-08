variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "instance_role" {
  type = string
}

variable "region" {
  type = string
}

variable "ami_name" {
  type        = string
  description = "name of AMI"
}

variable "number_dc" {
  type        = number
  description = "number of Domain controllers to create"
}
variable "number_bastion" {
  type        = number
  description = "number of bastion hosts create"
}
