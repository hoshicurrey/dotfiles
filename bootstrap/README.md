## Setup (Ubuntu)
1. Run setup script

git clone https://github.com/hoshicurrey/dotfiles.git
cd dotfiles/setup
```bash
chmod +x setup.sh
./setup.sh
```
This installs:
- system packages
- R
- development libraries
- NVIDIA driver

2. Reboot
GPU driver activation requires reboot.

```bash
sudo reboot
```
3. Verify GPU
After reboot:
```bash
nvidia-smi
```
Expected: NVIDIA GPU and driver version are displayed.

5. Login to Tailscale
```bash
sudo tailscale up
```


## Setup (macOS)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/hoshicurrey/dotfiles/main/bootstrap/setup_mac.sh)"
```

This script:
- Installs Homebrew (if not already installed)
- Clones dotfiles to `~/dotfiles`
- Creates `~/.ssh` and `~/.aws` directories
- Links dotfiles via `stow` (ssh, aws, git, zsh, brew)
- Installs packages from Brewfile
- Installs R `renv` package
- Creates `~/work/{projects,data,tmp}` directories