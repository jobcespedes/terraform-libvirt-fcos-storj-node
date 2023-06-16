data "template_file" "butane_snippet_install_storj_node" {
  template = <<TEMPLATE
---
variant: fcos
version: 1.4.0
storage:
  files:
    # pkg dependencies to be installed by additional-rpms.service
    - path: /var/lib/additional-rpms.list
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
          if [ ! -f "${local.data_volume_path}/config.yaml" ]; then
            echo "Setting up storj-node..."
            podman kill storj-node 2>/dev/null || echo
            podman rm storj-node 2>/dev/null || echo
            podman run --pull never --rm -e SETUP="true" \
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
              --name storj-node ${local.storj_node_image} ${join(" ", var.extra_parameters)}
            echo "storj-node set up..."
          else
            echo "storj-node config.yaml detected, not setting up..."
          fi

          # install
          echo "Installing storj-node service..."
          podman kill storj-node 2>/dev/null || echo
          podman rm storj-node 2>/dev/null || echo
          podman create --pull never --rm --restart on-failure --stop-timeout ${local.systemd_stop_timeout} \
            %{~if var.cpus_limit > 0~}
            --cpus ${var.cpus_limit} \
            %{~endif~}
            %{~if var.memory_limit != ""~}
            --memory ${var.memory_limit} \
            %{~endif~}
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
            --name storj-node ${local.storj_node_image} ${join(" ", var.extra_parameters)}
          podman generate systemd --new \
            --restart-sec 15 \
            --start-timeout 180 \
            --stop-timeout ${local.systemd_stop_timeout} \
            --after storj-node-image-pull.service \
            --name storj-node > /etc/systemd/system/storj-node.service
          systemctl daemon-reload
          systemctl enable storj-node.service
          echo "storj-node service installed..."
systemd:
  units:
    - name: storj-node-image-pull.service
      enabled: true
      contents: |
        [Unit]
        Description="Pull storj node image"
        Wants=network-online.target
        After=network-online.target
        Before=install-storj-node.service
        Before=storj-node.service

        [Service]
        Type=oneshot
        RemainAfterExit=yes
        Restart=on-failure
        RestartSec=10
        TimeoutStartSec=180
        ExecStart=/usr/bin/podman pull ${local.storj_node_image}

        [Install]
        WantedBy=multi-user.target
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
        After=additional-rpms.service
        After=storj-node-image-pull.service
        OnSuccess=storj-node.service
        ConditionPathExists=/usr/local/bin/storj-node-installer.sh
        ConditionPathExists=!/var/lib/%N.done
        StartLimitInterval=700
        StartLimitBurst=3

        [Service]
        Type=oneshot
        Restart=on-failure
        RestartSec=60
        TimeoutStartSec=200
        ExecStart=/usr/local/bin/storj-node-installer.sh
        ExecStart=/bin/touch /var/lib/%N.done

        [Install]
        WantedBy=multi-user.target
TEMPLATE
}
