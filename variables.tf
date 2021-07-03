variable "project" {
  default = "proven-agility-317407"
}

variable "region" {
  default = "us-west1"
}

variable "zone" {
  default = "us-west1-a"
}

variable "network_name" {
  default = "eq-ex-network"
}

variable "routing_mode" {
  default = "GLOBAL"
}

variable "gce_ssh_user" {
  default = "syed23irfan"
}

variable "gce_ssh_pub_key_file" {
  default = "./ssh-pub-key"
}

variable "instance_startup_script" {
  default = "./bin/setup-bastion.sh"
}