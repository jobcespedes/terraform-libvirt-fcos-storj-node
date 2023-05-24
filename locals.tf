locals {
  data_volume_path     = "/var/mnt/data"
  storj_node_dir_path  = "/var/opt/store-node"
  systemd_stop_timeout = 300
  storj_node_image     = "${var.image.name}:${var.image.version}:"
}
