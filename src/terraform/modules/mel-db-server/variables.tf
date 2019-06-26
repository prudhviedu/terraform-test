variable "instance_type" {}

variable "db_iam_instance_profile" {}

variable "vpc_security_group_ids" {
    type = "list"
}

variable "key_name" {}

variable "vpc" {}

variable "subnet_id" {}

variable "availability_zone" {}

variable "db_server_tags" {
    type = "map"
}

variable "db_ebs_tags" {
    type = "map"
}

variable "ami_id" {}

variable "volume_type" {}


variable "ebs_mount_size" {}

variable "user_data" {}
variable "root_volume_size" {}
variable "hostname" {
  default = ""
}
 variable "private_ip" {
     default = ""
 }
