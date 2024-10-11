resource "hcloud_server" "bootstrap" {
  count = var.bootstrap_enabled ? 1 : 0
  depends_on = [null_resource.ignition_post_deploy]
  name = "bootstrap.${var.cluster_name}.${var.base_domain}"
  image = var.image
  server_type = var.bootstrap_server_type
  keep_disk = true
  location = var.region
  ssh_keys = [
    hcloud_ssh_key.okd4.id]
}

resource "hcloud_rdns" "bootstrap" {
  count = var.bootstrap_enabled ? 1 : 0
  server_id = hcloud_server.bootstrap[0].id
  ip_address = hcloud_server.bootstrap[0].ipv4_address
  dns_ptr = "bootstrap.${var.cluster_name}.${var.base_domain}"
}

resource "null_resource" "bootstrap_post_deploy" {
  count = var.bootstrap_enabled ? 1 : 0
  connection {
    host = hcloud_server.bootstrap[0].ipv4_address
    type = "ssh"
    user = "root"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content = data.template_file.grub-bootstrap[0].rendered
    destination = "/etc/grub.d/40_custom"
  }

  provisioner "remote-exec" {
    inline = [
      "curl http://${hcloud_server.ignition[0].ipv4_address}/fcos-installer-kernel -o /boot/fcos-installer-kernel",
      "curl http://${hcloud_server.ignition[0].ipv4_address}/fcos-initramfs.img -o /boot/fcos-initramfs.img",
      "curl http://${hcloud_server.ignition[0].ipv4_address}/fcos-rootfs.img -o /boot/fcos-rootfs.img",
      "grub2-set-default 2",
      "grub2-mkconfig --output=/boot/grub2/grub.cfg",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "reboot",
    ]
    on_failure = continue
  }
}

resource "aws_route53_record" "bootstrap" {
  count   = var.bootstrap_enabled ? 1 : 0
  zone_id = var.route53_zone_id
  name    = "bootstrap.${var.cluster_name}.${var.base_domain}"
  type    = "A"
  ttl     = 120
  records = [hcloud_server.bootstrap[0].ipv4_address]
}

