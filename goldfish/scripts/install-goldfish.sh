#!/usr/bin/env bash
set -x

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT $0: $1"
}

logger "Running"
DIR=$(dirname "$0")
VERSION=v0.9.0
FILENAME="goldfish-linux-amd64"
GOLDFISH_SHASUM=a716db6277afcac21a404b6155d0c52b1d633f27d39fba240aae4b9d67d70943
URL=${URL:-"https://github.com/Caiyeon/goldfish/releases/download/${VERSION}/${FILENAME}"}
SHASUM="a716db6277afcac21a404b6155d0c52b1d633f27d39fba240aae4b9d67d70943"
logger "Current directory is ${DIR}"

logger "Downloading goldfish ${VERSION}"
curl --silent --location --output /tmp/${FILENAME} ${URL}
echo "${SHASUM} */tmp/$FILENAME" | shasum -a 256 -c -;

logger "Installing goldfish"
sudo adduser --system --no-create-home --group goldfish
sudo cp /tmp/${FILENAME} /usr/local/bin/goldfish
sudo chmod 0755 /usr/local/bin/goldfish
sudo chown goldfish:goldfish /usr/local/bin/goldfish
sudo mkdir -pm 0755 /etc/goldfish.d
sudo mkdir -pm 0755 /etc/ssl/goldfish

logger "/usr/local/bin/goldfish --version: $(/usr/local/bin/goldfish --version)"

logger "Configuring goldfish ${VERSION}"
sudo cp ${DIR}/../config/* /etc/goldfish.d
sudo chown -R goldfish:goldfish /etc/goldfish.d /etc/ssl/goldfish
sudo chmod -R 0644 /etc/goldfish.d/*

logger "Granting mlock syscall to goldfish binary"
sudo setcap cap_ipc_lock=+ep /usr/local/bin/goldfish

logger "Complete"
