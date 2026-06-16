#!/usr/bin/env bash

# Aktiviert die geforderte strikte Fehlerbehandlung
set -eEuo pipefail

msg_info "Installing Dependencies"
$STD apt-get update
$STD apt-get install -y curl sudo mc git
msg_ok "Installed Dependencies"

msg_info "Installing Node.js"
$STD bash <(curl -fsSL https://deb.nodesource.com/setup_20.x)
$STD apt-get install -y nodejs
msg_ok "Installed Node.js"

msg_info "Installing dm-hero"
$STD git clone https://github.com/Flo0806/dm-hero.git /opt/dm-hero
cd /opt/dm-hero
$STD npm install
$STD npm run build
msg_ok "Installed dm-hero"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/dm-hero.service
[Unit]
Description=dm-hero - Campaign Management Tool for Dungeons & Dragons
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/dm-hero
ExecStart=/usr/bin/npm run start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now dm-hero.service
msg_ok "Created Service"

msg_info "Cleaning up"
$STD apt-get autoremove -y
$STD apt-get clean
msg_ok "Cleaned up"