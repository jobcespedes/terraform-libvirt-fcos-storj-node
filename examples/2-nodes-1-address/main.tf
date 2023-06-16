######################### values #########################
locals {
  # module
  minimum_gb_in_bytes = 1000 * 1000 * 1000 * 560 # 560GB
  # vm resources
  vcpu   = 1
  memory = 1024
  # container limits
  cpus_limit   = 0.7
  memory_limit = "700m"
  # storj node
  external_address = "mynodes.example.com"
  port             = 28967
  wallet           = "0xChangeme"
  email            = "changeme@changeme.com"
  extra_parameters = [
    "--operator.wallet-features=zksync" # optional
  ]
  image = {
    name    = "docker.io/storjlabs/storagenode"
    version = "latest"
  }
  # butane common
  ssh_authorized_key = "ssh-rsa changeme"
  nameservers = [
    "8.8.8.8",
  ]
  timezone = "America/Costa_Rica"
  keymap   = "latam"
  # grub_password_hash: grub.pbkdf2.sha512.10000.DA15B9D5C0E04CDD6510922F9B6027B9DFE36CA65EBEC335A72321D0354BCCE9E531858765C6FE03F53EBF9ABF7E35EAE2861D27D4E6E1302C906F5276D35D90.A32FFEDB2A223426DD561C6F90DA5AB043A59B3CE074326AA88CCD4B3EA9CE8F014DD33B75C3E46DD3DD5E0EE50AE9B380E6E191E3DC5086D6536B55D734268E
  rollout_wariness = "0.5"
  periodic_updates = {
    time_zone = "localtime"
    windows = [
      {
        days           = ["Sat"],
        start_time     = "23:30",
        length_minutes = "60"
      },
      {
        days           = ["Sun"],
        start_time     = "00:30",
        length_minutes = "60"
      }
    ]
  }
  # libvirt
  root_volume_pool = "default"
  root_volume_size = 1024 * 1024 * 1024 * 10 # 10 Gi
  log_volume_pool  = "default"
  log_volume_size  = 1024 * 1024 * 1024 * 5 # 5 Gi
  nodes = [
    {
      # storj node
      storage       = local.minimum_gb_in_bytes
      external_port = 28967
      # livbirt
      fqdn             = "storj-node-01.example.com"
      mac              = "50:50:10:10:15:11"
      cidr_ip_address  = "10.10.15.11/24"
      vcpu             = local.vcpu
      memory           = local.memory
      data_volume_pool = "default"
      data_volume_size = local.minimum_gb_in_bytes
    },
    {
      # storj node
      storage       = local.minimum_gb_in_bytes
      external_port = 28968
      # livbirt
      fqdn             = "storj-node-02.example.com"
      mac              = "50:50:10:10:15:12"
      cidr_ip_address  = "10.10.15.12/24"
      vcpu             = local.vcpu
      memory           = local.memory
      data_volume_pool = "default"
      data_volume_size = local.minimum_gb_in_bytes
    }
  ]

  # network
  net_cidr_ipv4 = "10.10.15.0/24"
  net_cidr_ipv6 = "2001:db8:ca2:5::/64"

  # image
  fcos_image_version   = "37.20230303.3.0"
  fcos_image_arch      = "x86_64"
  fcos_image_stream    = "stable"
  fcos_image_sha256sum = "98bf7b4707439ac8a0cc35ced01f5fab450ccbe5be56d8ae1a7b630d1c3ab0ae"
  fcos_image_url       = "https://builds.coreos.fedoraproject.org/prod/streams/${local.fcos_image_stream}/builds/${local.fcos_image_version}/${local.fcos_image_arch}/fedora-coreos-${local.fcos_image_version}-qemu.${local.fcos_image_arch}.qcow2.xz"
  fcos_image_name      = "fcos-${local.fcos_image_stream}-${local.fcos_image_version}-${local.fcos_image_arch}.qcow2"
}

# network
resource "libvirt_network" "libvirt_fcos_base" {
  name      = "libvirt-fcos-base"
  mode      = "nat"
  domain    = "cluster.local"
  addresses = [local.net_cidr_ipv4, local.net_cidr_ipv6]
}

# image
resource "null_resource" "fcos_image_download" {
  provisioner "local-exec" {
    command = <<-TEMPLATE
      pushd /tmp
      if [ ! -f "${local.fcos_image_name}" ]; then
        curl -L "${local.fcos_image_url}" -o "${local.fcos_image_name}.xz"
        echo "${local.fcos_image_sha256sum} ${local.fcos_image_name}.xz" | sha256sum -c
        unxz "${local.fcos_image_name}.xz"
      fi
      popd
    TEMPLATE
  }
}

resource "libvirt_volume" "fcos_image" {
  depends_on = [null_resource.fcos_image_download]

  name   = "terraform-libvirt-fcos-example-base-${local.fcos_image_name}"
  source = "/tmp/${local.fcos_image_name}"
}

######################## module #########################
module "storj_node" {
  count = length(local.nodes)

  source = "../.."

  # storj
  image                = local.image
  address              = "${local.external_address}:${local.nodes[count.index].external_port}"
  port                 = local.port
  storage              = local.nodes[count.index].storage
  wallet               = local.wallet
  email                = local.email
  extra_parameters     = local.extra_parameters
  signed_ca_cert       = file(pathexpand("~/.local/share/storj/identity/${local.nodes[count.index].fqdn}/ca.cert"))
  signed_identity_cert = file(pathexpand("~/.local/share/storj/identity/${local.nodes[count.index].fqdn}/identity.cert"))
  identity_key         = file(pathexpand("~/.local/share/storj/identity/${local.nodes[count.index].fqdn}/identity.key"))
  cpus_limit           = local.cpus_limit
  memory_limit         = local.memory_limit
  # butane common
  fqdn               = local.nodes[count.index].fqdn
  cidr_ip_address    = local.nodes[count.index].cidr_ip_address
  mac                = local.nodes[count.index].mac
  ssh_authorized_key = local.ssh_authorized_key
  nameservers        = local.nameservers
  timezone           = local.timezone
  rollout_wariness   = local.rollout_wariness
  periodic_updates   = local.periodic_updates
  keymap             = local.keymap
  # libvirt
  vcpu             = local.nodes[count.index].vcpu
  memory           = local.nodes[count.index].memory
  root_volume_pool = local.root_volume_pool
  root_volume_size = local.root_volume_size
  log_volume_size  = local.log_volume_size
  log_volume_pool  = local.log_volume_pool
  data_volume_pool = local.nodes[count.index].data_volume_pool
  data_volume_size = local.nodes[count.index].data_volume_size

  root_base_volume_name = libvirt_volume.fcos_image.name
  network_id            = libvirt_network.libvirt_fcos_base.id
}
