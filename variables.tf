variable "cluster_name" {
  description = "prefix for cloud resources"
  type        = string
}

variable "worker_os" {
  description = "OS to run on worker machines"

  # valid choices are:
  # * ubuntu
  # * centos
  default = "ubuntu"
  type    = string
}

variable "ssh_public_key_file" {
  description = "SSH public key file"
  default     = "~/.ssh/id_rsa.pub.save"
  type        = string
}

variable "ssh_port" {
  description = "SSH port to be used to provision instances"
  default     = 22
  type        = number
}

variable "ssh_username" {
  description = "SSH user, used only in output"
  default     = "root"
  type        = string
}

variable "ssh_private_key_file" {
  description = "SSH private key file used to access instances"
  default     = ""
  type        = string
}

variable "ssh_agent_socket" {
  description = "SSH Agent socket, default to grab from $SSH_AUTH_SOCK"
  default     = "env:SSH_AUTH_SOCK"
  type        = string
}

# Provider specific settings

variable "control_plane_type" {
  default = "cx21"
  type    = string
}

variable "worker_type" {
  default = "cx21"
  type    = string
}

variable "workers_replicas" {
  default = 2
  type    = number
}

variable "lb_type" {
  default = "lb11"
  type    = string
}

variable "datacenter" {
  default = "nbg1"
  type    = string
}

variable "image" {
  default = "ubuntu-20.04"
  type    = string
}

variable "ip_range" {
  default     = "192.168.0.0/16"
  description = "ip range to use for private network"
  type        = string
}

variable "network_zone" {
  default     = "eu-central"
  description = "network zone to use for private network"
  type        = string
}
