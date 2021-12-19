resource "hcloud_ssh_key" "kubeone" {
  name       = "kubeone-${var.cluster_name}"
  public_key = file(var.ssh_public_key_file)
}

resource "hcloud_network" "net" {
  name     = var.cluster_name
  ip_range = var.ip_range
}

resource "hcloud_network_subnet" "kubeone" {
  network_id   = hcloud_network.net.id
  type         = "server"
  network_zone = var.network_zone
  ip_range     = var.ip_range
}

resource "hcloud_server_network" "control_plane" {
  count     = 2
  server_id = element(hcloud_server.control_plane.*.id, count.index)
  subnet_id = hcloud_network_subnet.kubeone.id
}

resource "hcloud_server" "control_plane" {
  count       = 2
  name        = "${var.cluster_name}-control-plane-${count.index + 1}"
  server_type = var.control_plane_type
  image       = var.image
  location    = var.datacenter

  ssh_keys = [
    hcloud_ssh_key.kubeone.id,
  ]

  labels = {
    "kubeone_cluster_name" = var.cluster_name
    "role"                 = "api"
  }
}
resource "hcloud_load_balancer_network" "load_balancer" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  subnet_id        = hcloud_network_subnet.kubeone.id
}

resource "hcloud_load_balancer" "load_balancer" {
  name               = "${var.cluster_name}-lb"
  load_balancer_type = var.lb_type
  location           = var.datacenter

  labels = {
    "kubeone_cluster_name" = var.cluster_name
    "role"                 = "lb"
  }
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  count            = 2
  server_id        = element(hcloud_server.control_plane.*.id, count.index)
  use_private_ip   = true
  depends_on = [
    hcloud_server_network.control_plane,
    hcloud_load_balancer_network.load_balancer
  ]
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

## Update OS
resource "null_resource" "createipfile" {
  triggers = {
   trigger = timestamp()
  }
  provisioner "local-exec" {
   command = "/usr/bin/hcloud server list | awk '{print $4}' | grep -v IP > ips.txt"
  }
}
locals {
  list_ip = compact(split("\n", file("ips.txt") ))
  depends_on = [null_resource.createipfile]
}
resource "null_resource" "os_update" {
triggers = {
  trigger = timestamp()
}
  provisioner "file" {
    source      = "upgrade_os"
    destination = "/tmp/upgrade_os"
  }

  for_each = toset(local.list_ip)
  connection {
    host = each.key
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
    agent    = "false"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 775 /tmp/upgrade_os ",
      "/tmp/upgrade_os",
    ]
  }
}