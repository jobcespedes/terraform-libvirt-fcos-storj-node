# storj node
variable "image" {
  type = object(
    {
      name    = optional(string, "docker.io/storjlabs/storagenode")
      version = optional(string, "latest")
    }
  )
  description = "/etc/host list"
  default     = null
}

variable "port" {
  type        = number
  default     = 28967
  description = "Storj node port"
  nullable    = false
}

variable "storage" {
  type        = string
  description = "Allocated disk space"
}

variable "address" {
  type        = string
  description = "Storj address/public ip"
}

variable "email" {
  type        = string
  description = "Operator's email"
}

variable "wallet" {
  type        = string
  description = "Operator's wallet"
}


variable "log_level" {
  type        = string
  default     = null
  description = "Operator's wallet"
}

variable "signed_ca_cert" {
  type        = string
  description = "Signed ca certificate. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity)"
  sensitive   = true
}

variable "signed_identity_cert" {
  type        = string
  description = "Signed identity certificate. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity)"
  sensitive   = true
}

variable "identity_key" {
  type        = string
  description = "Identity key. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity)"
  sensitive   = true
}

variable "extra_parameters" {
  type        = list(string)
  description = "List of extra paramenters appending when running storagenode container"
  default     = []
  nullable    = false
}

# butane common
variable "ssh_authorized_key" {
  type        = string
  description = "Authorized ssh key for core user"
}

variable "nameservers" {
  type        = list(string)
  description = "List of nameservers for VMs"
  default     = ["8.8.8.8"]
  nullable    = false
}

variable "timezone" {
  type        = string
  description = "Timezone for VMs as listed by `timedatectl list-timezones`"
  default     = null
}

variable "rollout_wariness" {
  type        = string
  description = "Wariness to update, 1.0 (very cautious) to 0.0 (very eager)"
  default     = null
}

variable "periodic_updates" {
  type = object(
    {
      time_zone = optional(string, "")
      windows = list(
        object(
          {
            days           = list(string)
            start_time     = string
            length_minutes = string
          }
        )
      )
    }
  )
  description = <<-TEMPLATE
    Only reboot for updates during certain timeframes
    {
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
  TEMPLATE
  default     = null
}

variable "keymap" {
  type        = string
  description = "Keymap"
  default     = null
}

variable "etc_hosts" {
  type = list(
    object(
      {
        ip       = string
        hostname = string
        fqdn     = string
      }
    )
  )
  description = "/etc/host list"
  default     = null
}

variable "etc_hosts_extra" {
  type        = string
  description = "/etc/host extra block"
  default     = null
}

# libvirt node
variable "fqdn" {
  type        = string
  description = "Node FQDN"
}

variable "cidr_ip_address" {
  type        = string
  description = "CIDR IP Address. Ex: 192.168.1.101/24"
  validation {
    condition     = can(cidrhost(var.cidr_ip_address, 1))
    error_message = "Check cidr_ip_address format"
  }
  default = null
}

variable "mac" {
  type        = string
  description = "Mac address"
  default     = null
}

variable "cpu_mode" {
  type        = string
  description = "Libvirt default cpu mode for VMs"
  default     = null
}

variable "vcpu" {
  type        = number
  description = "Node default vcpu count"
  default     = null
}

variable "memory" {
  type        = number
  description = "Node default memory in MiB"
  default     = 512
  nullable    = false
}

variable "root_volume_pool" {
  type        = string
  description = "Node default root volume pool"
  default     = null
}

variable "root_volume_size" {
  type        = number
  description = "Node default root volume size in bytes"
  default     = null
}

variable "root_base_volume_name" {
  type        = string
  description = "Node default base root volume name"
  nullable    = false
}

variable "root_base_volume_pool" {
  type        = string
  description = "Node default base root volume pool"
  default     = null
}

variable "log_volume_pool" {
  type        = string
  description = "Node default log volume pool"
  default     = null
}

variable "log_volume_size" {
  type        = number
  description = "Node default log volume size in bytes"
  default     = null
}

variable "data_volume_pool" {
  type        = string
  description = "Node default data volume pool"
  default     = null
}

variable "data_volume_size" {
  type        = number
  description = "Node default data volume size in bytes"
  default     = null
}

variable "ignition_pool" {
  type        = string
  description = "Default ignition files pool"
  default     = null
}

variable "wait_for_lease" {
  type        = bool
  description = "Wait for network lease"
  default     = null
}

variable "autostart" {
  type        = bool
  description = "Autostart with libvirt host"
  default     = null
}

variable "network_bridge" {
  type        = string
  description = "Libvirt default network bridge name for VMs"
  default     = null
}

variable "network_id" {
  type        = string
  description = "Libvirt default network id for VMs"
  default     = null
}

variable "network_name" {
  type        = string
  description = "Libvirt default network name for VMs"
  default     = null
}
