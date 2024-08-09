#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to apply post install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                      |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

if ! source "global_fn.sh"; then
    echo -e "\033[0;31m[ERROR]\033[0m unable to source global_fn.sh..."
    exit 1
fi
export CURRENT_LOG_LEVEL=0

# 1 .SDKman
setup_sdkman() {
    [[ -d "$HOME/.sdkman" ]] || curl -s "https://get.sdkman.io" | bash
}

# 2. Setup Spotify
setup_spotify() {
    echoinf "Setting up spotify..."
    if ! pkg_installed "spicetify-cli" "spicetify-marketplace-bin"; then
        echoerr "spicetify-cli or spicetify-marketplace-bin is not installed"
    fi
    if [ ! -d "/opt/spotify/" ] || [ ! -d "/opt/spotify/Apps/" ]; then
        echoerr "/opt/spotify/Apps doesn't exist"
    fi
    sudo chmod a+wr /opt/spotify && sudo chmod a+wr /opt/spotify/Apps -R;
    spicetify backup apply
    spicetify config inject_css 1
    spicetify config replace_colors 1
    spicetify config current_theme marketplace
    spicetify config custom_apps marketplace
    spicetify apply
    echoscs "Successfully set up spotify"
}

# 3. Tmux & Neovim
setup_tmux_neovim() {
    echoinf "Installing tmux and nvim config dependencies ..."
    if ! pkg_installed "luarocks" "tpm" "lua51" "tmux"; then
        echoerr "Please ensure these packages are installed: luarocks npm tmux lua51"
        return 1
    fi
    if [ ! -f "$HOME/.tmux.conf" ]; then
        echoerr "$HOME/.tmux.conf doesn't exist. Make sure your dotfiles is properly applied using 'chezmoi apply'"
        return 1
    fi
    sudo npm install -g eslint @biomejs/biome
    luarocks install --local persistence.nvim
    luarocks install --local --lua-version=5.1 magick
    [[ -d "$HOME/.tmux" ]] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux new -s tmp -d
    tmux source-file ~/.tmux.conf
    tmux kill-ses -t tmp
    echoscs "Installed tmux and nvim config dependencies"
}

# 4. Remove wallbashdiscord
remove_wallbash_discord() {
    echoinf "Removing wallbashdiscord.sh..."
    if [ ! -f "$HOME/.local/share/bin/wallbashdiscord.sh" ]; then
        echoskp "wallbashdiscord.sh is already removed"
        return 0
    fi
    rm ~/.local/share/bin/wallbashdiscord.sh
    echoscs "Removed wallbashdiscord.sh"
}

# 5. Disable poweroff button
disable_poweroff_btn() {
    echoinf "Disabling poweroff button..."
    [[ -f "/etc/systemd/logind.conf" ]] && sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' "/etc/systemd/logind.conf"
    echoscs "Disabled poweroff button"
}

# 6. Change SDDM theme
setup_sddm_theme() {
    echoinf "Setting up SDDM theme..."
    if ! pkg_installed sddm || [ ! -d "/etc/sddm.conf.d"  ]; then
        echoerr "Please ensure SDDM is installed and file /etc/sddm.conf exists"
        return 1
    fi
    if [ ! -d "/usr/share/sddm/themes/sddm-astronaut-theme" ]; then
        sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
        sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
    fi
    if [ "$(grep -oP '(?<=^Current=).*' /etc/sddm.conf)" == "sddm-astronaut-theme" ]; then
        echoskp "SDDM theme is already sddm-astronaut-theme"
        return 0
    fi
    sudo sed -i 's/^\[Theme\].*/[Theme]\nCurrent=sddm-astronaut-theme/' /etc/sddm.conf || echo -e "\n[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee -a /etc/sddm.conf
    echoscs "Changed SDDM theme to sddm-astronaut-theme"
}

# 7. VirtualBox
setup_vbox() {
    if ! pkg_installed "virtualbox"  || [ ! -f "/sbin/vboxreload" ]; then
        echoerr "Please ensure virtualbox is installed and /sbin/vboxreload is executable"
        return 1
    fi
    echoinf "Reloading virtualbox ..."
    sudo /sbin/vboxreload
    echoscs "Reloaded virtualbox"
}

# 8. Replace code with visual-studio-code-bin
setup_code() {
    echoinf "Installing visual-studio-code-bin ..."
    if pkg_installed "visual-studio-code-bin"; then
        echoskp "visual-studio-code-bin is already installed"
        return 0
    fi
    yay -R --noconfirm code
    yay -S --noconfirm visual-studio-code-bin
    echoscs "Installed visual-studio-code-bin"
}

# 9. MariaDb
setup_mariadb() {
    echoinf "Setting up mariadb..."
    if ! pkg_installed "mariadb"; then
        echoerr "Mariadb is not installed"
        return 1
    fi
    sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    config_file="/etc/my.cnf.d/client.cnf"
    if ! grep -Fxq "auto-rehash" "$config_file"; then
        echo "auto-rehash" | sudo tee -a "$config_file"
    else
        echoskp "auto-rehash is already present in /etc/my.cnf.d/client.cnf"
    fi
    sudo systemctl restart mariadb
    echoscs "Successfully set up mariadb"
}

# 10. Keyd
setup_keyd() {
    echoinf "Setting up keyd..."
    if ! pkg_installed "keyd"; then
        echoerr "keyd is not installed"
        return 1
    fi
    sudo systemctl enable keyd && sudo systemctl start keyd
    sudo mkdir -p /etc/default/
    sudo sh -c 'cat <<EOF > /etc/keyd/default.conf
[ids]

*

[main]

capslock = overload(control, esc)
EOF'
    sudo keyd reload
    echoscs "Successfully set up keyd"
}

# 11. Catppuccin Brave Theme
setup_brave_catppuccin() {
    # NOTE: import_brave_catppuccin.py doesn't work because is preventing automated software from running it
    echoinf "Installing Catppuccin theme for brave..."
    if [ ! -f "$scrDir/import.json" ]; then
        echoerr "File $scrDir/import.json not found"
        return 1
    fi
    mkdir -p "$HOME/tmp"
    cp "$scrDir/import.json" "$HOME/tmp"
    echoinf "Click 'import' button on the left, navigate to ~/tmp, and click on 'import.json'"
    brave --app=chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/manage.html > /dev/null 2>&1
    echoscs "Successfully installed Catppuccin theme for brave"
}


init "$1"
setup_sdkman
setup_spotify
setup_tmux_neovim
# remove_wallbash_discord
disable_poweroff_btn
setup_sddm_theme
setup_vbox
setup_code
setup_mariadb
setup_keyd
setup_brave_catppuccin
