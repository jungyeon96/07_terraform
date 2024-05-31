#!/bin/bash
exec > /var/log/docker.log 2>&1
echo "====== [START] Docker Installation Log ======="
echo "[Phase 01] Install essential packages."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

echo "[Phase 02] Create GPG key."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[Phase 03] Setup APT repository."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "[Phase 04] Install Docker packages."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[Phase 05] Setup the user (ubuntu)."
sudo usermod -aG docker ubuntu

echo "[Phase 06] Enable the Docker service."
sudo systemctl enable --now docker

echo "====== [END] Docker Installation Log ======="
