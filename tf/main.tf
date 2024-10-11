resource "hcloud_ssh_key" "okd4" {
  name = "okd4"
  public_key = file(var.public_key_path)
}

locals {
  grub_bootstrap_template = var.bootstrap_enabled ? templatefile("${path.module}/tpl/40_custom.tpl", {
    ignition_hostname = hcloud_server.ignition[0].ipv4_address
    server_role = "bootstrap"
    server_ip = hcloud_server.bootstrap[0].ipv4_address
    server_gateway = var.server_gateway
    server_netmask = var.server_netmask
    server_hostname = aws_route53_record.bootstrap[0].fqdn
    server_nameserver = var.dns_server
  }) : ""
}

locals {
  grub_master_templates = var.ignition_enabled ? [for index in range(var.master_count) : templatefile("${path.module}/tpl/40_custom.tpl", {
    ignition_hostname = hcloud_server.ignition[0].ipv4_address
    server_role = "master"
    server_ip = hcloud_server.master[index].ipv4_address
    server_gateway = var.server_gateway
    server_netmask = var.server_netmask
    server_hostname = aws_route53_record.master[index].fqdn
    server_nameserver = var.dns_server
  })] : []
}

locals {
  grub_worker_templates = var.ignition_enabled ? [for index in range(var.worker_count) : templatefile("${path.module}/tpl/40_custom.tpl", {
    ignition_hostname = hcloud_server.ignition[0].ipv4_address
    server_role = "worker"
    server_ip = hcloud_server.worker[index].ipv4_address
    server_gateway = var.server_gateway
    server_netmask = var.server_netmask
    server_hostname = aws_route53_record.worker[index].fqdn
    server_nameserver = var.dns_server
  })] : []
}

