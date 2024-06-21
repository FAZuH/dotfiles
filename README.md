# dotfiles

Warning: Chezmoi requires a passphrase to decrypt certain files.

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

#### Install Window Manager

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

sh -c "$(curl -fsLS get.chezmoi.io)" -- init FAZuH

eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519 && chezmoi cd

git remote set-url origin git@github.com:FAZuH/dotfiles.git && chezmoi apply

exit

sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' /etc/systemd/logind.conf

mkdir -p ~/.local/share/applications && echo -e "[Desktop Entry]\nVersion=1.0\nName=LINE\nComment=Line Messanger application\nExec=chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html\nIcon=/home/faz/.config/chromium/Default/Extensions/ophjlpahpchlmihnnnihgmmeilfjmjjc/3.3.0_0/line_logo_128x128_on.png\nTerminal=false\nType=Application" | tee ~/.local/share/applications/line.desktop

echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

# non NVIDIA GPU
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg
# NVIDIA GPU
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1"/' /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg

echo 'source = ~/.config/hypr/nvidia.conf' >> ~/.config/hypr/hyprland.conf

yay -S downgrade --noconfirm && sudo downgrade hyprland && reboot
```

#### Download & Install Applications

```bash
# Discord
yay -S flatpak --noconfirm && flatpak install io.github.spacingbat3.webcord

# Visual Studio Code
yay -R code && yay -S visual-studio-code-bin --noconfirm

# Mariadb
yay -S mariadb --noconfirm && mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql && echo "auto-rehash" | sudo tee -a /etc/my.cnf.d/client.cnf && sudo systemctl restart mariadb

# Tmux & Neovim
yay -S tmux ripgrep ttf-fira-code ttf-firacode-nerd luarocks nodejs npm pnpm --noconfirm && sudo luarocks install persistence.nvim && sudo npm install -g eslint @biomejs/biome && tmux && tmux source-file ~/.tmux.conf
# \<prefix>I to install plugins on tmux. source-file then.

# SDDM Theme
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme && sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/

# Spotify
yay -S spotify spicetify-cli --noconfirm && sudo chmod a+wr /opt/spotify && sudo chmod a+wr /opt/spotify/Apps -R

# OCR
yay -S python-pip && sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED && pip install pix2tex && yay -S tesseract tesseract-eng-data tesseract-data-jpn --noconfirm

# Download chromium and download LINE
yay -S chromium --noconfirm && chromium https://chromewebstore.google.com/detail/line/ophjlpahpchlmihnnnihgmmeilfjmjjc?hl=en

# Apps
yay -S hyde-cli-git qrencode gnome-clocks tree noto-fonts-emoji wget chromium \
    cava btop neofetch ani-cli mov-cli neovim kitty ranger encryptpad rclone \
    rclone-browser pavucontrol zathura zathura-pdf-mupdf ranger nautilus nchat \
    multimc-bin whatsie obsidian obs-studio --noconfirm

# Heavy Apps
yay -S jdk21-openjdk intellij-idea-community-edition intellij-idea-ultimate-edition pycharm-community-edition pycharm-professional android-studio virtualbox virtualbox-host-modules-arch qbittorrent-git ventoy-bin --noconfirm && sudo /sbin/vboxreload
```

#### Setup SSH

```bash
sudo su root

pacman -S ufw openssh --noconfirm && sed -i 's/#Port 22/Port 6519/g' /etc/ssh/sshd_config && ufw allow 6519 && ufw enable && ufw status numbered && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && systemctl enable sshd && systemctl start sshd && systemctl status sshd && pacman -S libpam-google-authenticator --noconfirm && google-authenticator && systemctl restart sshd && curl http://ifconfig.me
```
