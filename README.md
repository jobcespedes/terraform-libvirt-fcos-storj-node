Terraform module for creating a [Storj Node](https://www.storj.io/node/) using [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/), [Podman](https://podman.io/) and [Libvirt](https://libvirt.org/).

## Dependencies
The following are the dependencies to create k3s cluster with this module:
* [libvirt](https://libvirt.org/)

## Prerequisites
- Steps 1 to 5 from [storj node setup](https://docs.storj.io/node/setup), including [storj node identity](https://docs.storj.io/node/dependencies/identity) to then pass the correspondeing certificates and keys to the module variables.

## Requirements

| Name                                                                      | Version  |
| ------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_ct"></a> [ct](#requirement\_ct)                      | 0.11.0   |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt)       | ~> 0.7   |

## Providers

| Name                                                             | Version |
| ---------------------------------------------------------------- | ------- |
| <a name="provider_template"></a> [template](#provider\_template) | n/a     |

## Modules

| Name                                             | Source                   | Version |
| ------------------------------------------------ | ------------------------ | ------- |
| <a name="module_fcos"></a> [fcos](#module\_fcos) | krestomatio/fcos/libvirt | 0.0.9   |

## Resources

| Name                                                                                                                                        | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [template_file.butane_snippet_install_storj_node](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name                                                                                                        | Description                                                                                                                                                   | Type                                                                                                                                                         | Default                          | Required |
| ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------- | :------: |
| <a name="input_address"></a> [address](#input\_address)                                                     | Storj address/public ip                                                                                                                                       | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_autostart"></a> [autostart](#input\_autostart)                                               | Autostart with libvirt host                                                                                                                                   | `bool`                                                                                                                                                       | `null`                           |    no    |
| <a name="input_cidr_ip_address"></a> [cidr\_ip\_address](#input\_cidr\_ip\_address)                         | CIDR IP Address. Ex: 192.168.1.101/24                                                                                                                         | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_cpu_mode"></a> [cpu\_mode](#input\_cpu\_mode)                                                | Libvirt default cpu mode for VMs                                                                                                                              | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_data_volume_pool"></a> [data\_volume\_pool](#input\_data\_volume\_pool)                      | Node default data volume pool                                                                                                                                 | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_data_volume_size"></a> [data\_volume\_size](#input\_data\_volume\_size)                      | Node default data volume size in bytes                                                                                                                        | `number`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_email"></a> [email](#input\_email)                                                           | Operator's email                                                                                                                                              | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_etc_hosts"></a> [etc\_hosts](#input\_etc\_hosts)                                             | /etc/host list                                                                                                                                                | <pre>list(<br>    object(<br>      {<br>        ip       = string<br>        hostname = string<br>        fqdn     = string<br>      }<br>    )<br>  )</pre> | `null`                           |    no    |
| <a name="input_etc_hosts_extra"></a> [etc\_hosts\_extra](#input\_etc\_hosts\_extra)                         | /etc/host extra block                                                                                                                                         | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_extra_parameters"></a> [extra\_parameters](#input\_extra\_parameters)                        | List of extra paramenters appending when running storagenode container                                                                                        | `list(string)`                                                                                                                                               | `[]`                             |    no    |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn)                                                              | Node FQDN                                                                                                                                                     | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_identity_key"></a> [identity\_key](#input\_identity\_key)                                    | Identity key. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity)                                            | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_ignition_pool"></a> [ignition\_pool](#input\_ignition\_pool)                                 | Default ignition files pool                                                                                                                                   | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_keymap"></a> [keymap](#input\_keymap)                                                        | Keymap                                                                                                                                                        | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level)                                             | Operator's wallet                                                                                                                                             | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_log_volume_pool"></a> [log\_volume\_pool](#input\_log\_volume\_pool)                         | Node default log volume pool                                                                                                                                  | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_log_volume_size"></a> [log\_volume\_size](#input\_log\_volume\_size)                         | Node default log volume size in bytes                                                                                                                         | `number`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_mac"></a> [mac](#input\_mac)                                                                 | Mac address                                                                                                                                                   | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_memory"></a> [memory](#input\_memory)                                                        | Node default memory in MiB                                                                                                                                    | `number`                                                                                                                                                     | `512`                            |    no    |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers)                                         | List of nameservers for VMs                                                                                                                                   | `list(string)`                                                                                                                                               | <pre>[<br>  "8.8.8.8"<br>]</pre> |    no    |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge)                              | Libvirt default network bridge name for VMs                                                                                                                   | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id)                                          | Libvirt default network id for VMs                                                                                                                            | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name)                                    | Libvirt default network name for VMs                                                                                                                          | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_port"></a> [port](#input\_port)                                                              | Storj node port                                                                                                                                               | `number`                                                                                                                                                     | `28967`                          |    no    |
| <a name="input_rollout_wariness"></a> [rollout\_wariness](#input\_rollout\_wariness)                        | Wariness to update, 1.0 (very cautious) to 0.0 (very eager)                                                                                                   | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_root_base_volume_name"></a> [root\_base\_volume\_name](#input\_root\_base\_volume\_name)     | Node default base root volume name                                                                                                                            | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_root_base_volume_pool"></a> [root\_base\_volume\_pool](#input\_root\_base\_volume\_pool)     | Node default base root volume pool                                                                                                                            | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_root_volume_pool"></a> [root\_volume\_pool](#input\_root\_volume\_pool)                      | Node default root volume pool                                                                                                                                 | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size)                      | Node default root volume size in bytes                                                                                                                        | `number`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_signed_ca_cert"></a> [signed\_ca\_cert](#input\_signed\_ca\_cert)                            | Signed ca certificate. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity)                                   | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_signed_identity_cert"></a> [signed\_identity\_cert](#input\_signed\_identity\_cert)          | Signed identity certificate. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity)                             | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_ssh_authorized_key"></a> [ssh\_authorized\_key](#input\_ssh\_authorized\_key)                | Authorized ssh key for core user                                                                                                                              | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_storage"></a> [storage](#input\_storage)                                                     | Allocated disk space                                                                                                                                          | `string`                                                                                                                                                     | n/a                              |   yes    |
| <a name="input_timezone"></a> [timezone](#input\_timezone)                                                  | Timezone for VMs as listed by `timedatectl list-timezones`                                                                                                    | `string`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_updates_periodic_window"></a> [updates\_periodic\_window](#input\_updates\_periodic\_window) | Only reboot for updates during certain timeframes<br>{<br>  days           = ["Sat", "Sun"],<br>  start\_time     = "22:30",<br>  length\_minutes = "60"<br>} | <pre>object({<br>    days           = list(string)<br>    start_time     = string<br>    length_minutes = string<br>  })</pre>                               | `null`                           |    no    |
| <a name="input_vcpu"></a> [vcpu](#input\_vcpu)                                                              | Node default vcpu count                                                                                                                                       | `number`                                                                                                                                                     | `null`                           |    no    |
| <a name="input_wait_for_lease"></a> [wait\_for\_lease](#input\_wait\_for\_lease)                            | Wait for network lease                                                                                                                                        | `bool`                                                                                                                                                       | `null`                           |    no    |
| <a name="input_wallet"></a> [wallet](#input\_wallet)                                                        | Operator's wallet                                                                                                                                             | `string`                                                                                                                                                     | n/a                              |   yes    |

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_ct"></a> [ct](#requirement\_ct) | 0.11.0 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | ~> 0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_fcos"></a> [fcos](#module\_fcos) | krestomatio/fcos/libvirt | 0.0.24 |

## Resources

| Name | Type |
|------|------|
| [template_file.butane_snippet_install_storj_node](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address"></a> [address](#input\_address) | Storj address/public ip | `string` | n/a | yes |
| <a name="input_autostart"></a> [autostart](#input\_autostart) | Autostart with libvirt host | `bool` | `null` | no |
| <a name="input_cidr_ip_address"></a> [cidr\_ip\_address](#input\_cidr\_ip\_address) | CIDR IP Address. Ex: 192.168.1.101/24 | `string` | `null` | no |
| <a name="input_cpu_mode"></a> [cpu\_mode](#input\_cpu\_mode) | Libvirt default cpu mode for VMs | `string` | `null` | no |
| <a name="input_data_volume_pool"></a> [data\_volume\_pool](#input\_data\_volume\_pool) | Node default data volume pool | `string` | `null` | no |
| <a name="input_data_volume_size"></a> [data\_volume\_size](#input\_data\_volume\_size) | Node default data volume size in bytes | `number` | `null` | no |
| <a name="input_email"></a> [email](#input\_email) | Operator's email | `string` | n/a | yes |
| <a name="input_etc_hosts"></a> [etc\_hosts](#input\_etc\_hosts) | /etc/host list | <pre>list(<br>    object(<br>      {<br>        ip       = string<br>        hostname = string<br>        fqdn     = string<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_etc_hosts_extra"></a> [etc\_hosts\_extra](#input\_etc\_hosts\_extra) | /etc/host extra block | `string` | `null` | no |
| <a name="input_extra_parameters"></a> [extra\_parameters](#input\_extra\_parameters) | List of extra paramenters appending when running storagenode container | `list(string)` | `[]` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | Node FQDN | `string` | n/a | yes |
| <a name="input_identity_key"></a> [identity\_key](#input\_identity\_key) | Identity key. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity) | `string` | n/a | yes |
| <a name="input_ignition_pool"></a> [ignition\_pool](#input\_ignition\_pool) | Default ignition files pool | `string` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | /etc/host list | <pre>object(<br>    {<br>      name    = optional(string, "docker.io/storjlabs/storagenode")<br>      version = optional(string, "latest")<br>    }<br>  )</pre> | <pre>{<br>  "name": "docker.io/storjlabs/storagenode",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_keymap"></a> [keymap](#input\_keymap) | Keymap | `string` | `null` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Operator's wallet | `string` | `null` | no |
| <a name="input_log_volume_pool"></a> [log\_volume\_pool](#input\_log\_volume\_pool) | Node default log volume pool | `string` | `null` | no |
| <a name="input_log_volume_size"></a> [log\_volume\_size](#input\_log\_volume\_size) | Node default log volume size in bytes | `number` | `null` | no |
| <a name="input_mac"></a> [mac](#input\_mac) | Mac address | `string` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Node default memory in MiB | `number` | `512` | no |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers) | List of nameservers for VMs | `list(string)` | <pre>[<br>  "8.8.8.8"<br>]</pre> | no |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge) | Libvirt default network bridge name for VMs | `string` | `null` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | Libvirt default network id for VMs | `string` | `null` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Libvirt default network name for VMs | `string` | `null` | no |
| <a name="input_periodic_updates"></a> [periodic\_updates](#input\_periodic\_updates) | Only reboot for updates during certain timeframes<br>{<br>  time\_zone = "localtime"<br>  windows = [<br>    {<br>      days           = ["Sat"],<br>      start\_time     = "23:30",<br>      length\_minutes = "60"<br>    },<br>    {<br>      days           = ["Sun"],<br>      start\_time     = "00:30",<br>      length\_minutes = "60"<br>    }<br>  ]<br>} | <pre>object(<br>    {<br>      time_zone = optional(string, "")<br>      windows = list(<br>        object(<br>          {<br>            days           = list(string)<br>            start_time     = string<br>            length_minutes = string<br>          }<br>        )<br>      )<br>    }<br>  )</pre> | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | Storj node port | `number` | `28967` | no |
| <a name="input_rollout_wariness"></a> [rollout\_wariness](#input\_rollout\_wariness) | Wariness to update, 1.0 (very cautious) to 0.0 (very eager) | `string` | `null` | no |
| <a name="input_root_base_volume_name"></a> [root\_base\_volume\_name](#input\_root\_base\_volume\_name) | Node default base root volume name | `string` | n/a | yes |
| <a name="input_root_base_volume_pool"></a> [root\_base\_volume\_pool](#input\_root\_base\_volume\_pool) | Node default base root volume pool | `string` | `null` | no |
| <a name="input_root_volume_pool"></a> [root\_volume\_pool](#input\_root\_volume\_pool) | Node default root volume pool | `string` | `null` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Node default root volume size in bytes | `number` | `null` | no |
| <a name="input_signed_ca_cert"></a> [signed\_ca\_cert](#input\_signed\_ca\_cert) | Signed ca certificate. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity) | `string` | n/a | yes |
| <a name="input_signed_identity_cert"></a> [signed\_identity\_cert](#input\_signed\_identity\_cert) | Signed identity certificate. It should be previously [generated following docs](https://docs.storj.io/node/dependencies/identity) | `string` | n/a | yes |
| <a name="input_ssh_authorized_key"></a> [ssh\_authorized\_key](#input\_ssh\_authorized\_key) | Authorized ssh key for core user | `string` | n/a | yes |
| <a name="input_storage"></a> [storage](#input\_storage) | Allocated disk space | `string` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone for VMs as listed by `timedatectl list-timezones` | `string` | `null` | no |
| <a name="input_vcpu"></a> [vcpu](#input\_vcpu) | Node default vcpu count | `number` | `null` | no |
| <a name="input_wait_for_lease"></a> [wait\_for\_lease](#input\_wait\_for\_lease) | Wait for network lease | `bool` | `null` | no |
| <a name="input_wallet"></a> [wallet](#input\_wallet) | Operator's wallet | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->