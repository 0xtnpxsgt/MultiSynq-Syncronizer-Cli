#!/usr/bin/env bash

# Automate creation of multiple synchronizer instances
set -e

NUM_INSTANCES=${1:-3}
BASE_PORT=3333

for i in $(seq 1 "$NUM_INSTANCES"); do
    inst=$(printf "%02d" "$i")
    inst_dir="/root/.synchronizer-cli-instance-${inst}"

    echo "Initializing instance ${inst}..."
    synchronizer init

    mkdir -p "$inst_dir"
    cp -r /root/.synchronizer-cli/* "$inst_dir/"

    port=$((BASE_PORT + i - 1))
    service_file="/etc/systemd/system/synchronizer-cli-${inst}.service"

    cat <<SERVICE > "$service_file"
[Unit]
Description=Synchronizer Instance ${inst}
After=docker.service
Requires=docker.service

[Service]
Type=simple
User=root
Restart=always
RestartSec=10
ExecStart=/usr/bin/docker run --rm --name synchronizer-cli-${inst} --pull always \
  --platform linux/amd64 \
  -v ${inst_dir}/config.json:/app/config.json \
  -p ${port}:3333 \
  cdrakep/synqchronizer:latest \
  --depin wss://api.multisynq.io/depin \
  --sync-name synq-XXXXXXXXX \
  --launcher cli-2.6.1/docker-2025-06-07 \
  --key <KEY_${inst}> \
  --wallet <WALLET_${inst}>

[Install]
WantedBy=multi-user.target
SERVICE

done

systemctl daemon-reload
