#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt update

apt install -y \
  git \
  tmux \
  stow \
  htop \
  rsync \
  wget \
  curl \
  unzip \
  zip \
  build-essential \
  cmake \
  pkg-config \
  software-properties-common \
  dirmngr \
  gpg \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  libudunits2-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libfreetype6-dev

# CRAN key
curl -fsSL https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | gpg --dearmor -o /usr/share/keyrings/cran.gpg

# CRAN repository
echo "deb [signed-by=/usr/share/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" \
  > /etc/apt/sources.list.d/cran-r.list

apt update

# R install
apt install -y r-base r-base-dev

# work directory
mkdir -p /work/projects
mkdir -p /work/data
mkdir -p /work/tmp
chown -R ubuntu:ubuntu /work

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up \
  --auth-key REMOVED_TAILSCALE_KEY \
  --hostname ec2-research \
  --ssh \
  --reset

# renv
R -q -e "options(repos='https://cloud.r-project.org'); install.packages('renv')"

# dotfiles
sudo -u ubuntu git clone https://github.com/hoshicurrey/dotfiles.git /home/ubuntu/dotfiles
sudo -u ubuntu stow -d /home/ubuntu/dotfiles -t /home/ubuntu .
