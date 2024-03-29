module "fcos" {
  source  = "krestomatio/fcos/libvirt"
  version = "0.0.30"

  # custom
  butane_snippets_additional = compact(
    [
      data.template_file.butane_snippet_install_storj_node.rendered
    ]
  )

  # common
  fqdn               = var.fqdn
  cidr_ip_address    = var.cidr_ip_address
  mac                = var.mac
  ssh_authorized_key = var.ssh_authorized_key
  nameservers        = var.nameservers
  timezone           = var.timezone
  rollout_wariness   = var.rollout_wariness
  periodic_updates   = var.periodic_updates
  keymap             = var.keymap
  etc_hosts          = var.etc_hosts
  etc_hosts_extra    = var.etc_hosts_extra
  # libvirt
  cpu_mode              = var.cpu_mode
  vcpu                  = var.vcpu
  memory                = var.memory
  root_volume_pool      = var.root_volume_pool
  root_volume_size      = var.root_volume_size
  root_base_volume_name = var.root_base_volume_name
  root_base_volume_pool = var.root_base_volume_pool
  log_volume_size       = var.log_volume_size
  log_volume_pool       = var.log_volume_pool
  data_volume_pool      = var.data_volume_pool
  data_volume_path      = local.data_volume_path
  data_volume_size      = var.data_volume_size
  backup_volume         = false
  swap_volume           = var.swap_volume
  swap_volume_pool      = var.swap_volume_pool
  swap_volume_size      = var.swap_volume_size
  ignition_pool         = var.ignition_pool
  autostart             = var.autostart
  wait_for_lease        = var.wait_for_lease
  network_id            = var.network_id
  network_bridge        = var.network_bridge
  network_name          = var.network_name
}
