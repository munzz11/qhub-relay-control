#!/usr/bin/env bash
# Install qhub-relay-control as a systemd service that starts at boot.
# Run as a normal user; sudo is invoked only where needed.
set -e

SERVICE="qhub-relay-control"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PYTHON="$(which python3)"
RUN_USER="$(whoami)"
UNIT="/etc/systemd/system/${SERVICE}.service"

if [[ "$(uname)" != "Linux" ]]; then
    echo "This script is for Linux (systemd) only." >&2
    exit 1
fi

if ! command -v systemctl &>/dev/null; then
    echo "systemd not found on this system." >&2
    exit 1
fi

echo "Installing ${SERVICE} systemd unit..."
echo "  Repo:    ${REPO_DIR}"
echo "  Python:  ${PYTHON}"
echo "  User:    ${RUN_USER}"
echo "  Unit:    ${UNIT}"
echo

sudo tee "${UNIT}" > /dev/null <<EOF
[Unit]
Description=Q-Hub Relay Control
After=network.target

[Service]
Type=simple
User=${RUN_USER}
WorkingDirectory=${REPO_DIR}
ExecStart=${PYTHON} ${REPO_DIR}/run.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE}"
sudo systemctl restart "${SERVICE}"

echo "Done. Useful commands:"
echo "  sudo systemctl status  ${SERVICE}"
echo "  sudo journalctl -u ${SERVICE} -f"
echo "  sudo systemctl stop    ${SERVICE}"
echo "  sudo systemctl disable ${SERVICE}"
