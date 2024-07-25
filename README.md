# dotfiles

FAZuH's personal hyprland dotfiles. Modification of [Prasanth Rangan's Hyprland dotfiles](https://github.com/prasanthrangan/hyprdots)

> [!WARNING]
> 
> These dotfiles are not designed for public use; you may need to adjust them to suit your own device.
>
> Chezmoi requires a passphrase to decrypt certain files.

## Installation

### Install Arch Linux

```bash
# Connect to wifi
iwctl

station wlan0 connect SSID

exit

archinstall
# archinstall, user: faz, minimal, git, pipewire, networkmanager, multilib

reboot
```

### Install Original Dotfiles (Hyprland)

```bash
nmcli d wifi connect SID password PASSWORD

git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE && cd ~/HyDE/Scripts && ./install.sh -drs
# AUR helper    : yay
# Shell         : zsh
# Font          : notos
# SDDM          : corners
# Theme         : tokyonight
# Wallpaper     : lowpoly_street / street / cat_lofi_cafe
# Flatpaks      : Don't install
# App chooser   : Style 2
```

### Install Personalized Dotfiles

#### Download and Apply Dotfiles

```bash
# Install dotfiles manager (chezmoi) and encyption tool (age)
cd ~ && yay -S --noconfirm chezmoi age openssh

# Download and apply personalized dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply FAZuH

# Load ssh keys for github
eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519

# Set git remote url
chezmoi cd && git remote set-url origin git@github.com:FAZuH/dotfiles.git
```

#### Install Applications

- Install applications with install script on `Scripts/install.sh`

- Options:
    - None : Full personalized dotfiles setup, excluding heavy apps.
    - `--install` : Install apps listed on list_apps only.
    - `--heavy` : Install apps listed on list_apps_heavy only.

> [!WARNING]
> 
> Running `install.sh` with `--heavy` may take a long time due to the download and compilation size.

#### Setup SSH

```bash
sudo su root

pacman -S --noconfirm ufw openssh libpam-google-authenticator \
    && sed -i 's/#Port 22/Port 6519/g' /etc/ssh/sshd_config \
    && ufw allow 6519 && ufw enable && ufw status numbered \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && systemctl enable sshd && systemctl start sshd && google-authenticator && systemctl restart sshd
```
