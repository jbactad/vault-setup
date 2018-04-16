#! /bin/env bash
sudo rm -rf /etc/consul.d \
    /etc/vault.d \
    /etc/goldfish.d \
    /opt/consul \
    /opt/vault \
    /lib/systemd/system/consul* \
    /lib/systemd/system/vault.service \
    /lib/systemd/system/goldfish.service \
    /usr/local/bin/vault \
    /usr/local/bin/consul \
    /usr/local/bin/goldfish
