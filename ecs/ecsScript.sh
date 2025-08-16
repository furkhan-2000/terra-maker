#!/bin/bash
set -e
# CRITICAL: Tell EC2 which ECS cluster to join
echo ECS_CLUSTER=apple-cluster >> /etc/ecs/ecs.config

# Update packages
sudo yum update -y && sudo yum upgrade -y

# Install Docker Compose only if missing  
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi
