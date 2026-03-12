#!/usr/bin/env bash
set -e

echo "=== macOS Setup ==="

# --- Homebrew ---
echo "--- Homebrew ---"
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed. Skipping."
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# --- dotfiles ---
echo "--- dotfiles ---"
if [ ! -d ~/dotfiles ]; then
  git clone https://github.com/hoshicurrey/dotfiles.git ~/dotfiles
else
  echo "~/dotfiles already exists. Skipping clone."
fi

# --- Directories ---
echo "--- Directories ---"
mkdir -p ~/.ssh && chmod 700 ~/.ssh
mkdir -p ~/.aws
mkdir -p ~/work/{projects,data,tmp}

# --- stow ---
echo "--- stow ---"
cd ~/dotfiles
stow ssh aws git zsh brew

# --- Brewfile ---
echo "--- Brewfile ---"
brew bundle --file ~/dotfiles/brew/Brewfile

# --- R packages ---
echo "--- R packages ---"
R -q -e "options(repos='https://cloud.r-project.org'); install.packages('renv')"

echo "=== Setup complete ==="

