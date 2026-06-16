#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts ORG
# Author: DEIN-GITHUB-NAME
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/Flo0806/dm-hero

# Variablen gemäß offiziellem Styleguide komplett in Kleinbuchstaben
APP="dm-hero"
var_tags="${var_tags:-games;campaign-management}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-1024}"          
var_disk="${var_disk:-4}"           
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_arm64="${var_arm64:-no}"
var_unprivileged="${var_unprivileged:-1}"

# Framework initialisieren
header_info "${APP}"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -d /opt/dm-hero ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Updating ${APP} via Git"
  cd /opt/dm-hero || msg_error "Failed to change directory to /opt/dm-hero"
  
  git stash &>/dev/null || true
  git pull
  msg_ok "Pulled latest changes"

  msg_info "Rebuilding Frontend and Dependencies"
  $STD npm install
  $STD npm run build
  msg_ok "Rebuilt successfully"

  msg_info "Restarting Service"
  systemctl restart dm-hero
  msg_ok "Started Service"
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW}Access it using the following URL:${CL}"
echo -e "${GATEWAY}${BGN}http://${IP}:3000${CL}"