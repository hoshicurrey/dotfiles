#!/usr/bin/env bash
set -e

echo "Installing Homebrew packages..."

# Homebrew
if ! command -v brew &> /dev/null
then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

cd ~/dotfiles

echo "Preparing directories..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "Linking dotfiles..."
brew install stow
stow */

echo "Installing Brewfile packages..."
cd brew
brew bundle

echo "Bootstrap complete."
