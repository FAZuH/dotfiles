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
```

- **archinstall, user: faz, minimal, git, pipewire, networkmanager, multilib**

#### Reboot

```bash
reboot
```

### Setup

#### Connect to Internet

```bash
nmcli d wifi connect SID password PASSWORD
```

#### Install Window Manager

```bash
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE && cd ~/HyDE/Scripts && ./install.sh
```

- **AUR helper: yay**
- **Shell: zsh**
- **Font: notos**
- **Don't install flatpaks**
- **SDDM: Corners**
- **Theme: tokyonight**
- **Wallpaper: lowpoly_street**
- **App chooser: Style 2**

#### Commands

```bash
yay -S chezmoi age

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply FAZuH

sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' /etc/systemd/logind.conf

eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519

# non NVIDIA GPU
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg

 # NVIDIA GPU
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1"/' /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg

mkdir ~/.local/share/applications

echo -e "[Desktop Entry]\nVersion=1.0\nName=LINE\nComment=Line Messanger application\nExec=chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html\nIcon=/home/faz/.config/chromium/Default/Extensions/ophjlpahpchlmihnnnihgmmeilfjmjjc/3.3.0_0/line_logo_128x128_on.png\nTerminal=false\nType=Application" | tee ~/.local/share/applications/line.desktop

echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
```

#### Download & Install Applications

```bash
yay -S flatpak --noconfirm && flatpak install io.github.spacingbat3.webcord

yay -R code && yay -S visual-studio-code-bin --noconfirm

yay -S mariadb --noconfirm && mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

yay -S hyde-cli-git qrencode gnome-clocks tree noto-fonts-emoji wget chromium cava btop neofetch ani-cli mov-cli neovim kitty ranger encryptpad rclone rclone-browser pavucontrol zathura zathura-pdf-mupdf ranger nautilus --noconfirm

yay -S tmux ripgrep ttf-fira-code ttf-firacode-nerd luarocks nodejs npm pnpm --noconfirm && sudo luarocks install persistence.nvim && sudo npm install -g eslint @biomejs/biome && tmux source-file ~/.tmux.conf
# \<prefix>I to install plugins on tmux

sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme && sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/

yay -S jdk21-openjdk multimc-bin whatsie --noconfirm

yay -S spotify spicetify-cli --noconfirm && sudo chmod a+wr /opt/spotify && sudo chmod a+wr /opt/spotify/Apps -R

yay -S python-pip && sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED && pip install pix2tex && yay -S tesseract tesseract-eng-data tesseract-data-jpn --noconfirm

yay -S intellij-idea-community-edition intellij-idea-ultimate-edition pycharm-community-edition pycharm-professional android-studio virtualbox virtualbox-host-modules-arch qbittorrent-git ventoy-bin --noconfirm && sudo /sbin/vboxreload

# After chromium is installed
chromium https://chromewebstore.google.com/detail/line/ophjlpahpchlmihnnnihgmmeilfjmjjc?hl=en
```

#### Setup SSH

```bash
sudo su root

pacman -S ufw openssh --noconfirm && sed -i 's/#Port 22/Port 6519/g' /etc/ssh/sshd_config && ufw allow 6519 && ufw enable && ufw status numbered && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && systemctl enable sshd && systemctl start sshd && systemctl status sshd && pacman -S libpam-google-authenticator --noconfirm && google-authenticator && systemctl restart sshd && curl http://ifconfig.me
```
