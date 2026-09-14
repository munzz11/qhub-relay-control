#!/usr/bin/env bash
# Stop and remove the qhub-relay-control systemd service.
set -e

SERVICE="qhub-relay-control"
UNIT="/etc/systemd/system/${SERVICE}.service"

sudo systemctl stop    "${SERVICE}" 2>/dev/null || true
sudo systemctl disable "${SERVICE}" 2>/dev/null || true
sudo rm -f "${UNIT}"
sudo systemctl daemon-reload

echo "${SERVICE} service removed."
