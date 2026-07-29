#!/usr/bin/env bash
# ==============================================================================
# ADVANCED DISTRIBUTED OSINT PLATFORM - RAPID DEPLOYMENT SCRIPT
# ==============================================================================

set -euo pipefail
IFS=$'\n\t'

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

log() { echo -e "${CYAN}[*]${NC} $1"; }
success() { echo -e "${GREEN}[+]${NC} $1"; }
error() { echo -e "${RED}[!]${NC} $1" >&2; }

log "Updating system packages and installing baseline dependencies..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    ufw \
    jq \
    python3-pip \
    python3-venv \
    tor \
    torsocks

log "Configuring Docker repository and container runtime..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
success "Docker runtime installed successfully."

log "Provisioning directory layout for core architecture layers..."
INSTALL_DIR="/opt/osint_stack"
sudo mkdir -p "$INSTALL_DIR"/{data/neo4j,data/elasticsearch,data/spiderfoot,config,pipelines}
sudo chown -R $USER:$USER "$INSTALL_DIR"
cd "$INSTALL_DIR"

log "Writing enterprise-grade multi-container orchestrator configuration..."
cat << 'DOCKEREOF' > docker-compose.yml
version: '3.8'

services:
  tor-proxy:
    image: dperson/torproxy
    container_name: osint_tor_proxy
    restart: unless-stopped
    ports:
      - "9050:9050"
      - "9051:9051"

  neo4j:
    image: neo4j:5.15.0-community
    container_name: osint_neo4j
    restart: unless-stopped
    environment:
      - NEO4J_AUTH=neo4j/ChangeThisDefaultSecurePassword123!
    ports:
      - "7474:7474"
      - "7687:7687"
    volumes:
      - ./data/neo4j:/data

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.3
    container_name: osint_elasticsearch
    restart: unless-stopped
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
    ports:
      - "9200:9200"
    volumes:
      - ./data/elasticsearch:/usr/share/elasticsearch/data

  spiderfoot:
    image: smicallef/spiderfoot:latest
    container_name: osint_spiderfoot
    restart: unless-stopped
    ports:
      - "5001:5001"
    volumes:
      - ./data/spiderfoot:/var/lib/spiderfoot
    command: ["python3", "./sf.py", "-l", "0.0.0.0:5001"]
DOCKEREOF

log "Configuring host firewall rules..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 7474/tcp
sudo ufw allow 5001/tcp
sudo ufw --force enable
success "Firewall rules applied."

log "Spinning up core infrastructure containers via Docker Compose..."
docker compose up -d

success "Deployment complete! Access your advanced platform nodes below:"
echo -e "${GREEN}------------------------------------------------------------${NC}"
echo -e " SpiderFoot Recon UI:  ${CYAN}http://<server-ip>:5001${NC}"
echo -e " Neo4j Graph DB UI:    ${CYAN}http://<server-ip>:7474${NC}"
echo -e " Elasticsearch API:    ${CYAN}http://<server-ip>:9200${NC}"
echo -e " Tor Proxy Gateway:    ${CYAN}socks5://<server-ip>:9050${NC}"
echo -e "${GREEN}------------------------------------------------------------${NC}"
