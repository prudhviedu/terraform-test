variable "instance_type" {}
variable "vpc_security_group_ids" {
    type = "list"
}
variable "key_name" {}
variable "subnet_id" {}
variable "tags" {
    type = "map"
}
variable "ami" {}
variable "availability_zone" {}
variable "user_data" {
    default = ""
}
variable "env" {}
variable "vpc" {}
variable "instance_role" {}
variable "volume_size" {
    default = 70
}
 variable "private_ip" {
     default = ""
 }

