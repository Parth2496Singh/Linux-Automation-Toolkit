#!/bin/bash
set -e

install_docker(){

    echo "Removing old Docker versions (if any)..."
    sudo apt remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true
    sudo apt autoremove -y || true

    echo "Updating system..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg

    echo "Creating keyring..."
    sudo install -m 0755 -d /etc/apt/keyrings

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg

    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo "Adding Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "Installing Docker..."
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Enabling Docker..."
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ubuntu
    newgrp docker || true

    
}

deploy_project(){
	if [ -d "Lost-and-Found-Platform-V2" ]; then
        	echo "Repo exists → pulling latest changes"
        	cd Lost-and-Found-Platform-V2
        	git pull
    	else
        	git clone https://github.com/Parth2496Singh/Lost-and-Found-Platform-V2.git
        	cd Lost-and-Found-Platform-V2
   	fi
	mkdir -p static
	docker compose up -d
}
if ! install_docker; then
	echo "Docker not installed properly"
	exit 1
fi

deploy_project
