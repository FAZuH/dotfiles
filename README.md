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
# Flatpaks      : Don't install
# SDDM          : Corners
# Theme         : tokyonight
# Wallpaper     : lowpoly_street.png/street.gif
# App chooser   : Style 2
```

### Install Personalized Dotfiles

```bash
# Install dotfiles manager (chezmoi) and encyption tool (age)
cd ~ && yay -S chezmoi age

# Download and apply personalized dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply FAZuH

# Load ssh keys for github
eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519

# Set git remote url
chezmoi cd && git remote set-url origin git@github.com:FAZuH/dotfiles.git
```

#### Install Applications

```bash
# Apps
yay -S --noconfirm \
    hyde-cli-git qrencode gnome-clocks tree noto-fonts-emoji wget brave cava btop neofetch \
    ani-cli neovim kitty encryptpad rclone pavucontrol zathura zathura-pdf-mupdf ranger nautilus \
    multimc-bin whatsie obsidian obs-studio downgrade net-tools vencord mariadb spotify \
    spicetify-cli tree-sitter-cli tmux imagemagick lua51 ripgrep ttf-fira-code ttf-firacode-nerd \
    luarocks nodejs npm pnpm 

# Heavy Apps
yay -S --noconfirm jdk21-openjdk intellij-idea-community-edition intellij-idea-ultimate-edition \
    pycharm-community-edition pycharm-professional android-studio virtualbox \
    virtualbox-host-modules-arch qbittorrent-git ventoy-bin python-pix2tex tesseract tesseract-eng-data tesseract-data-jpn


# Post
yay -R code && yay -S visual-studio-code-bin --noconfirm

# MariaDb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql \
    && echo "auto-rehash" | sudo tee -a /etc/my.cnf.d/client.cnf && sudo systemctl restart mariadb

# SDKman
curl -s "https://get.sdkman.io" | bash

# SDDM Theme
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme \
    && sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/

# Spotify
sudo chmod a+wr /opt/spotify && sudo chmod a+wr /opt/spotify/Apps -R
```

#### Post Installation

```bash
# Tmux & Neovim
sudo luarocks install persistence.nvim && sudo npm install -g eslint @biomejs/biome && tmux \
    && tmux source-file ~/.tmux.conf && sudo luarocks install --lua-version=5.1 magick
# \<prefix>I to install plugins on tmux. source-file then.

# Remove wallbashdiscord
rm ~/.local/share/bin/wallbashdiscord.sh

# Disable poweroff button
sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' /etc/systemd/logind.conf

# Change SDDM theme
echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

# VBox
sudo /sbin/vboxreload
```

#### Setup SSH

```bash
sudo su root

pacman -S --noconfirm ufw openssh libpam-google-authenticator \
    && sed -i 's/#Port 22/Port 6519/g' /etc/ssh/sshd_config \
    && ufw allow 6519 && ufw enable && ufw status numbered \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && systemctl enable sshd && systemctl start sshd && google-authenticator && systemctl restart sshd
```
