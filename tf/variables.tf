#
# Hetzner Cloud Variables
#
variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
}

#
# AWS Route 53 / DNS Variables
#
variable "aws_region" {
  description = "AWS region for Route 53"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key for Route 53"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key for Route 53"
  type        = string
}

variable "route53_zone_id" {
  description = "AWS Route 53 Zone ID"
  type        = string
}

#
# Load Balancer Variables
#
variable "load_balancer_type" {
  description = "Type of the load balancer"
  type        = string
  default     = "lb11" # Example load balancer type, modify as necessary
}

variable "load_balancer_algorithm" {
  description = "Algorithm used by the load balancer"
  type        = string
  default     = "least_connections" # Example algorithm, modify as necessary
}

#
# VM Variables
#
variable "image" {
  type    = string
  default = "stream-9"
}

variable "region" {
  description = "Create nodes in this region"
  type        = string
  default     = "fsn1"
}

#
# Domain Variables
#
variable "base_domain" {
  description = "Base domain for the cluster"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "okd"
}

#
# SSH Key Variables
#
variable "public_key_path" {
  description = "Path to the public key to access OKD4 nodes"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to the private key to access OKD4 nodes"
  type        = string
  default     = "~/.ssh/id_rsa"
}

#
# Ignition Variables
#
variable "ignition_enabled" {
  description = "Enable or disable the ignition server"
  type        = bool
  default     = true
}

variable "ignition_server_type" {
  description = "Server type for the ignition server"
  type        = string
  default     = "cx11"
}

#
# Fedora CoreOS Installer Variables
#
variable "fcos_installer_kernel" {
  description = "URL to the Fedora CoreOS installer kernel"
  type        = string
}

variable "fcos_installer_initramfs" {
  description = "URL to the Fedora CoreOS installer initramfs"
  type        = string
}

variable "fcos_rootfs" {
  description = "URL to the Fedora CoreOS rootfs image"
  type        = string
}

variable "fcos_metal_bios" {
  description = "URL to the Fedora CoreOS metal BIOS archive"
  type        = string
}

#
# OpenShift Installer Directory Variable
#
variable "openshift_installer_dir" {
  description = "Path to the OpenShift installer directory"
  type        = string
}

#
# Worker Node Variables
#
variable "worker_server_type" {
  description = "Server type for the worker nodes"
  type        = string
  default     = "cx31"
}

variable "worker_storage_enabled" {
  description = "Enable or disable additional storage for worker nodes"
  type        = bool
  default     = false
}

variable "worker_storage_size" {
  description = "Size of the additional storage for worker nodes (in GiB)"
  type        = number
  default     = 100
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

#
# Bootstrap Variables
#
variable "bootstrap_enabled" {
  description = "Enable or disable the bootstrap server"
  type        = bool
  default     = true
}

variable "bootstrap_server_type" {
  description = "Server type for the bootstrap server"
  type        = string
  default     = "cx41"
}

#
# Master Node Variables
#
variable "master_server_type" {
  description = "Server type for the master nodes"
  type        = string
  default     = "cx41"
}

variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 3
}

#
# Network Variables
#
variable "server_gateway" {
  description = "Gateway for the server network"
  type        = string
  default     = "172.31.1.1"
}

variable "server_netmask" {
  description = "Netmask for the server network"
  type        = string
  default     = "255.255.255.255"
}

variable "dns_server" {
  description = "DNS server for the network"
  type        = string
  default     = "8.8.8.8"
}

#
# Subdomain Variables
#
variable "subdomains" {
  description = "List of subdomains for the cluster"
  type        = list(string)
  default     = []
}
