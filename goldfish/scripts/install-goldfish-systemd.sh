#!/usr/bin/env bash
set -x

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT $0: $1"
}

logger "Running"
DIR=$(dirname "$0")

# Detect package management system.
YUM=$(which yum 2>/dev/null)
APT_GET=$(which apt-get 2>/dev/null)

logger "Current directory is ${DIR}"

if [[ ! -z ${YUM} ]]; then
  SYSTEMD_DIR="/etc/systemd/system"
  logger "Installing systemd services for RHEL/CentOS"
  sudo cp ${DIR}/../init/systemd/goldfish.service ${SYSTEMD_DIR}
  sudo chmod 0664 ${SYSTEMD_DIR}/goldfish.service
elif [[ ! -z ${APT_GET} ]]; then
  SYSTEMD_DIR="/lib/systemd/system"
  logger "Installing systemd services for Debian/Ubuntu"
  sudo cp ${DIR}/../init/systemd/goldfish.service ${SYSTEMD_DIR}
  sudo chmod 0664 ${SYSTEMD_DIR}/goldfish.service
else
  logger "Service not installed due to OS detection failure"
  exit 1;
fi

vault write auth/approle/role/goldfish \
    role_name=goldfish policies=default,goldfish \
    secret_id_num_uses=1 \
    secret_id_ttl=5m \
    period=24h \
    token_ttl=0 \
    token_max_ttl=0

vault write auth/approle/role/goldfish/role-id role_id=goldfish

# production goldfish needs a generic secret endpoint. See Configuration page for details
vault write secret/goldfish \
    DefaultSecretPath="secret/" \
    UserTransitKey="usertransit" \
    BulletinPath="secret/bulletins/"

sudo systemctl enable goldfish
sudo systemctl start goldfish

logger "Complete"
