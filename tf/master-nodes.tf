resource "hcloud_server" "master" {
  depends_on = [hcloud_server.bootstrap]
  count = var.master_count
  name = "master${count.index}.${var.cluster_name}.${var.base_domain}"
  image = var.image
  server_type = var.master_server_type
  keep_disk = true
  location = var.region
  ssh_keys = [
    hcloud_ssh_key.okd4.id]
}

resource "hcloud_rdns" "master" {
  count = var.master_count
  server_id = hcloud_server.master[count.index].id
  ip_address = hcloud_server.master[count.index].ipv4_address
  dns_ptr = "master${count.index}.${var.cluster_name}.${var.base_domain}"
}

resource "null_resource" "master_post_deploy" {
  count = var.master_count
  connection {
    host = hcloud_server.master[count.index].ipv4_address
    type = "ssh"
    user = "root"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content = data.template_file.grub-master[count.index].rendered
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

resource "aws_route53_record" "master" {
  count   = var.master_count
  zone_id = var.route53_zone_id
  name    = "master${count.index}.${var.cluster_name}.${var.base_domain}"
  type    = "A"
  ttl     = 120
  records = [hcloud_server.master[count.index].ipv4_address]
}

resource "aws_route53_record" "etcd" {
  count   = var.master_count
  zone_id = var.route53_zone_id
  name    = "etcd-${count.index}.${var.cluster_name}.${var.base_domain}"
  type    = "A"
  ttl     = 120
  records = [hcloud_server.master[count.index].ipv4_address]
}
