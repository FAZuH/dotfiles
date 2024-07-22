# dotfiles

Warning:

> [!WARNING]
> 
> These dotfiles are not designed for public use; you may need to adjust them to suit your own device.
> Checkout to branch `nvidia` if you're using an NVIDIA GPU. You'd also pull new git commits with --rebase, because new commits are pushed into `main` branch.
> Chezmoi requires a passphrase to decrypt certain files.
>

## Installation

### Archinstall

#### Install Archlinux

```bash
# Connect to wifi
iwctl

station wlan0 connect SSID

exit

archinstall
# archinstall, user: faz, minimal, git, pipewire, networkmanager, multilib

reboot
```

### Setup

#### Install Window Manager (Hyprland)

```bash
nmcli d wifi connect SID password PASSWORD

git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE && cd ~/HyDE/Scripts && ./install.sh
```

- **AUR helper: yay**
- **Shell: zsh**
- **Font: notos**
- **Don't install flatpaks**
- **SDDM: Corners**
- **Theme: tokyonight**
- **Wallpaper: lowpoly_street.png/street.gif**
- **App chooser: Style 2**

#### Commands

```bash
cd ~ && yay -S chezmoi age

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply FAZuH

eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519 && chezmoi cd

git remote set-url origin git@github.com:FAZuH/dotfiles.git

cd Documents/Scripts
# non NVIDIA GPU
chmod +x nonnvidia.sh && ./nonnvidia.sh
# NVIDIA GPU below
chmod +x nvidia.sh && ./nvidia.sh
```

#### Download & Install Applications

```bash
# Discord
yay -S vencord --noconfirm

# Visual Studio Code
yay -R code && yay -S visual-studio-code-bin --noconfirm

# Mariadb
yay -S mariadb --noconfirm && sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql \
    && echo "auto-rehash" | sudo tee -a /etc/my.cnf.d/client.cnf && sudo systemctl restart mariadb

# SDKman
curl -s "https://get.sdkman.io" | bash

# Tmux & Neovim
yay -S tree-sitter-cli tmux imagemagick lua51 ripgrep ttf-fira-code ttf-firacode-nerd luarocks nodejs npm pnpm --noconfirm \
    && sudo luarocks install persistence.nvim && sudo npm install -g eslint @biomejs/biome && tmux \
    && tmux source-file ~/.tmux.conf && sudo luarocks install --lua-version=5.1 magick
# \<prefix>I to install plugins on tmux. source-file then.

# SDDM Theme
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme \
    && sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/

# Spotify
yay -S spotify spicetify-cli --noconfirm && sudo chmod a+wr /opt/spotify && sudo chmod a+wr /opt/spotify/Apps -R

# OCR
yay -S python-pip && sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED && pip install pix2tex && yay -S tesseract tesseract-eng-data tesseract-data-jpn --noconfirm

# Install brave and add LINE extension
yay -S brave --noconfirm && brave https://chromewebstore.google.com/detail/line/ophjlpahpchlmihnnnihgmmeilfjmjjc?hl=en

# Apps
yay -S --noconfirm hyde-cli-git qrencode gnome-clocks tree noto-fonts-emoji wget chromium \
    cava btop neofetch ani-cli mov-cli neovim kitty ranger encryptpad rclone \
    rclone-browser pavucontrol zathura zathura-pdf-mupdf ranger nautilus nchat \
    multimc-bin whatsie obsidian obs-studio downgrade net-tools

# Heavy Apps
yay -S jdk21-openjdk intellij-idea-community-edition intellij-idea-ultimate-edition \
    pycharm-community-edition pycharm-professional android-studio virtualbox virtualbox-host-modules-arch \
    qbittorrent-git ventoy-bin --noconfirm && sudo /sbin/vboxreload
```

#### Setup SSH

```bash
sudo su root

pacman -S ufw openssh --noconfirm && sed -i 's/#Port 22/Port 6519/g' /etc/ssh/sshd_config && ufw allow 6519 && ufw enable && ufw status numbered && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && systemctl enable sshd && systemctl start sshd && systemctl status sshd && pacman -S libpam-google-authenticator --noconfirm && google-authenticator && systemctl restart sshd && curl http://ifconfig.me
```
