#!/bin/bash

#----------------------------------------------------------------------------------------
# Dev: Peter Ton
# Modified: 10 Nov 2017
# Created: 1 Sep 2017
# Description: This script installs apps/settings on Engineering builds and pushes the sites
# to devboxes. This should be run on the developer's machine after doing SSH keys, Devbox
# provisioning, DHCP reservations, DNS, and devbox proxy. This should be run WITHOUT sudo.
#----------------------------------------------------------------------------------------

# CHANGE THESE VALUES:
USER=mperkins
EMAIL=mperkins@cargurus.com

# Display message
echo “Starting CG Engineering Build install…“

# Install Xcode
xcode-select --install

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Java (needs to be version 8)
brew tap caskroom/versions
brew cask install java8

# Install Maven
brew install maven

# Install / Configure Node
brew install node
npm config set registry http://archive-eng.cargurus.com:8081/artifactory/api/npm/npm-registry

# Configure Chef and reset databases on NA and EU devboxes
ssh root@devbox-na-$USER "/root/devbox/chef/reconfigure-chef.sh -u $USER; /root/devbox/chef/run-chef-solo.sh; /root/devbox/scripts/reset_dev_box_db_binary.sh"
ssh root@devbox-eu-$USER "/root/devbox/chef/reconfigure-chef.sh -u $USER; /root/devbox/chef/run-chef-solo.sh; /root/devbox/scripts/reset_dev_box_db_binary.sh europe"

# Check out CG repository
mkdir ~/cargurus
git config --global user.name $USER
git config --global user.email $EMAIL
git clone git@code.cargurus.com:cargurus-eng/cg-main.git ~/cargurus/cg-main

# Deploy US, CA, and UK to devboxes
cd ~/cargurus/cg-main/cargurus-build/local/devbox-push
./build-webpack-resources.sh
./push-services-noninv.sh
./push-services-noninv.sh -c uk
./push-services-inv.sh
./push-services-inv.sh -c ca
./push-services-inv.sh -c uk
./push-website.sh
./push-website.sh -r eu

# Configure SSH key forwarding
echo -e "Host *\n User $USER\n IdentityFile ~/.ssh/id_rsa\n ForwardAgent yes\n ServerAliveInterval 100\n ServerAliveCountMax 2\n BatchMode no\n GSSAPIAuthentication no\n GSSAPIDelegateCredentials no\n Ciphers blowfish-cbc" > ~/.ssh/config
echo -e "SSH_ENV=\"\$HOME/.ssh/environment\"\n\nfunction start_agent {\n    echo \"Initializing new SSH agent...\"\n    touch \$SSH_ENV\n    chmod 600 \"\${SSH_ENV}\"\n    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >> \"\${SSH_ENV}\"\n    . \"\${SSH_ENV}\" > /dev/null\n    /usr/bin/ssh-add\n}\n\n# Source SSH settings, if applicable\nif [ -f \"\${SSH_ENV}\" ]; then\n    . \"\${SSH_ENV}\" > /dev/null\n    kill -0 \$SSH_AGENT_PID 2>/dev/null || {\n        start_agent\n    }\nelse\n    start_agent\nfi" >> ~/.bash_profile

# Display message
echo “Finished CG Engineering Build install…“

exit 0
