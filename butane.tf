data "template_file" "butane_snippet_install_storj_node" {
  template = <<TEMPLATE
---
variant: fcos
version: 1.4.0
storage:
  files:
    # pkg dependencies to be installed by os-additional-rpms.service
    - path: /var/lib/os-additional-rpms.list
      overwrite: false
      append:
        - inline: |
            firewalld
    - path: /etc/sysctl.d/udp_buffer.conf
      contents:
        inline: |
          net.core.rmem_max=2500000
    - path: ${local.storj_node_dir_path}/identity/ca.cert
      overwrite: true
      mode: 0644
      contents:
        inline: |
          ${indent(10, var.signed_ca_cert)}
    - path: ${local.storj_node_dir_path}/identity/identity.cert
      overwrite: true
      mode: 0644
      contents:
        inline: |
          ${indent(10, var.signed_identity_cert)}
    - path: ${local.storj_node_dir_path}/identity/identity.key
      overwrite: true
      mode: 0600
      contents:
        inline: |
          ${indent(10, var.identity_key)}
    - path: /usr/local/bin/storj-node-installer.sh
      mode: 0754
      overwrite: true
      contents:
        inline: |
          #!/bin/bash -e
          # vars

          ## firewalld rules
          if ! systemctl is-active firewalld &> /dev/null
          then
            echo "Enabling firewalld..."
            systemctl restart dbus.service
            restorecon -rv /etc/firewalld
            systemctl enable --now firewalld
            echo "Firewalld enabled..."
          fi
          # Add firewalld rules
          echo "Adding firewalld rules..."
          firewall-cmd --zone=public --permanent --add-port=${var.port}/tcp
          firewall-cmd --zone=public --permanent --add-port=${var.port}/udp
          firewall-cmd --reload
          echo "Firewalld rules added..."

          # setup
          echo "Setting up storj-node..."
          podman kill storj-node 2>/dev/null || echo
          podman rm storj-node 2>/dev/null || echo
          podman run --rm -e SETUP="true" \
            -p 28967:28967/tcp \
            -p 28967:28967/udp \
            -p 127.0.0.1:14002:14002 \
            -e WALLET="${var.wallet}" \
            -e EMAIL="${var.email}" \
            -e ADDRESS="${var.address}" \
            -e STORAGE="${var.storage}" \
            --user $(id -u):$(id -g) \
            --volume "${local.storj_node_dir_path}/identity:/app/identity:Z" \
            --volume "${local.data_volume_path}:/app/config:Z" \
            --name storj-node docker.io/storjlabs/storagenode:latest ${join(" ", var.extra_parameters)}
          echo "storj-node set up..."

          # install
          echo "Installing storj-node service..."
          podman kill storj-node 2>/dev/null || echo
          podman rm storj-node 2>/dev/null || echo
          podman create --pull newer --restart unless-stopped --stop-timeout 300 \
            -p 28967:28967/tcp \
            -p 28967:28967/udp \
            -p 127.0.0.1:14002:14002 \
            -e WALLET="${var.wallet}" \
            -e EMAIL="${var.email}" \
            -e ADDRESS="${var.address}" \
            -e STORAGE="${var.storage}" \
            --user $(id -u):$(id -g) \
            --volume "${local.storj_node_dir_path}/identity:/app/identity:Z" \
            --volume "${local.data_volume_path}:/app/config:Z" \
            --name storj-node docker.io/storjlabs/storagenode:latest ${join(" ", var.extra_parameters)}
          podman generate systemd --new --after install-storj-node.service --name storj-node > /etc/systemd/system/storj-node.service 
          systemctl daemon-reload
          systemctl enable --now storj-node.service
          echo "storj-node service installed..."
systemd:
  units:
    - name: install-storj-node.service
      enabled: true
      contents: |
        [Unit]
        Description=Install storj node
        # We run before `zincati.service` to avoid conflicting rpm-ostree
        # transactions.
        Before=zincati.service
        Wants=network-online.target
        After=network-online.target
        After=os-additional-rpms.service
        ConditionPathExists=/usr/local/bin/storj-node-installer.sh
        ConditionPathExists=!/var/lib/%N.done
        StartLimitInterval=500
        StartLimitBurst=3

        [Service]
        Type=oneshot
        RemainAfterExit=yes
        Restart=on-failure
        RestartSec=60
        TimeoutStartSec=300
        ExecStart=/usr/local/bin/storj-node-installer.sh
        ExecStart=/bin/touch /var/lib/%N.done

        [Install]
        WantedBy=multi-user.target
TEMPLATE
}
