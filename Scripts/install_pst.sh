#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to apply post install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                      |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

init() {
    scrDir=$(dirname "$(realpath "$0")")
    if ! source "${scrDir}/global_fn.sh"; then
        echo -e "\033[0;31m[ERROR]\033[0m unable to source global_fn.sh..."
        exit 1
    fi
}

# 1 .SDKman
setup_sdkman() {
    [[ -d "$HOME/.sdkman" ]] || curl -s "https://get.sdkman.io" | bash
}

# 2. Setup Spotify
setup_spotify() {
    if [ -d "/opt/spotify/" ] && [ -d "/opt/spotify/Apps/" ];
        then sudo chmod a+wr /opt/spotify && sudo chmod a+wr /opt/spotify/Apps -R;
    fi
}

# 3. Tmux & Neovim
setup_tmux_neovim() {
    if pkg_installed "luarocks" && pkg_installed "npm" && pkg_installed "tmux" && pkg_installed "lua51" && [ -f "$HOME/.tmux.conf" ]; then
        echoinf "Installing tmux and nvim config dependencies ..."
        sudo npm install -g eslint @biomejs/biome
        luarocks --local install persistence.nvim
        sudo luarocks install --lua-version=5.1 magick
        if [ ! -d "$HOME/.tmux" ]; then
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        fi
        tmux new -s tmp -d
        tmux source-file ~/.tmux.conf
        tmux kill-ses -t tmp
        echoscs "Installed tmux and nvim config dependencies"
    else
        echoerr -e "Please ensure these packages are installed:\nluarocks\nnpm\ntmux\nlua51"
    fi
}

# 4. Remove wallbashdiscord
remove_wallbash_discord() {
    if [ -f "$HOME/.local/share/bin/wallbashdiscord.sh" ]; then
        rm ~/.local/share/bin/wallbashdiscord.sh
        echoinf "Removed wallbashdiscord.sh"
    else
        echoskp "wallbashdiscord.sh is already removed"
    fi
}

# 5. Disable poweroff button
disable_poweroff_btn() {
    if [ -f "/etc/systemd/logind.conf" ]; then
        sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' "/etc/systemd/logind.conf"
        echoscs "Disabled poweroff button"
    fi
}

# 6. Change SDDM theme
setup_sddm_theme() {
    if pkg_installed sddm && [ -d "/etc/sddm.conf.d" ]; then
        if [ ! -d "/usr/share/sddm/themes/sddm-astronaut-theme" ]; then
            echoinf "Installing SDDM theme ..."
            sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
            sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
            printf "\Installed SDDM theme"
        else echoskp "SDDM theme is already installed"; fi
        if [ "$(grep -oP '(?<=^Current=).*' /etc/sddm.conf)" != "sddm-astronaut-theme" ]; then
            sudo sed -i 's/^\[Theme\].*/[Theme]\nCurrent=sddm-astronaut-theme/' /etc/sddm.conf || echo -e "\n[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee -a /etc/sddm.conf
            echoscs "Changed SDDM theme to sddm-astronaut-theme"
        else
            echoskp "SDDM theme is already sddm-astronaut-theme"
        fi
    else
        echoerr "Please ensure SDDM is installed and file /etc/sddm.conf exists"
    fi
}

# 7. VirtualBox
setup_vbox() {
    if pkg_installed "virtualbox" && [ -f "/sbin/vboxreload" ]; then
        echoinf "Reloading virtualbox ..."
        sudo /sbin/vboxreload
        echoscs "Reloaded virtualbox"
    else
        echoerr "Please ensure virtualbox is installed and /sbin/vboxreload is executable"
    fi
}

# 8. Replace code with visual-studio-code-bin
setup_code() {
    if ! pkg_installed "visual-studio-code-bin"; then
        echoinf "Installing visual-studio-code-bin ..."
        yay -R --noconfirm code
        yay -S --noconfirm visual-studio-code-bin
        echoscs "Installed visual-studio-code-bin"
    else echoskp "visual-studio-code-bin is already Installed"; fi
}

# 9. MariaDb
setup_mariadb() {
    if pkg_installed "mariadb"; then
        echoinf "Setting up mariadb ..."
        sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
        config_file="/etc/my.cnf.d/client.cnf"
        if ! grep -Fxq "auto-rehash" "$config_file"; then
            echo "auto-rehash" | sudo tee -a "$config_file"
        else
            echoskp "auto-rehash is already present in /etc/my.cnf.d/client.cnf"
        fi
        sudo systemctl restart mariadb
        echoscs "Successfully set up mariadb"
    fi
}

# 10. Keyd
setup_keyd() {
    echoinf "Setting up keyd"
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
    # Alternatively, disable BraveShield (NOT RECOMMENDED)
    echoinf "Installing Catppuccin theme for brave"
    if [ -f "$scrDir/import.json" ]; then
        mkdir -p "$HOME/tmp"
        cp "$scrDir/import.json" "$HOME/tmp"
        echoinf "Click 'import' button on the left, navigate to ~/tmp, and click on 'import.json'"
        brave --app=chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/manage.html > /dev/null 2>&1
        rm "$HOME/tmp/import.json"
        rmdir "$HOME/tmp"
        echoscs "Successfully installed Catppuccin theme for brave"
    else
        echoerr "File $scrDir/import.json not found"
    fi
}


main() {
    init
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
}

main
