#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to apply post install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                      |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
if ! source "${scrDir}/global_fn.sh"; then
    echo -e "\033[0;31m[ERROR]\033[0m unable to source global_fn.sh..."
    exit 1
fi

# 1 .SDKman
curl -s "https://get.sdkman.io" | bash

# 2. Setup Spotify
if [ -d "/opt/spotify/" ] && [ -d "/opt/spotify/Apps/" ]; then sudo chmod a+wr /opt/spotify && sudo chmod a+wr /opt/spotify/Apps -R; fi

# 3. Tmux & Neovim
if pkg_installed "luarocks" && pkg_installed "npm" && pkg_installed "tmux" && pkg_installed "lua51" && [ -f "$HOME/.tmux.conf" ]; then
    echoinf "Installing tmux and nvim config dependencies ..."
    # sudo luarocks install persistence.nvim 
    # sudo npm install -g eslint @biomejs/biomejs
    # # TODO: Test if installing locally works
    luarocks --local install persistence.nvim
    # TODO: Can't npm install for some reason
    # npm install --local -g eslint @biomejs/biomejs
    tmux new -s tmp -d
    tmux source-file ~/.tmux.conf
    sudo luarocks install --lua-version=5.1 magick
    tmux kill-ses -t tmp
    echoscs "Installed tmux and nvim config dependencies"
else
    echoerr -e "Please ensure these packages are installed:\nluarocks\nnpm\ntmux\nlua51"
fi

# 4. Remove wallbashdiscord
if [ -f "$HOME/.local/share/bin/wallbashdiscord.sh" ]; then
    rm ~/.local/share/bin/wallbashdiscord.sh
    echoinf "Removed wallbashdiscord.sh"
else
    echoskp "wallbashdiscord.sh is already removed"
fi

# 5. Disable poweroff button
if [ -f "/etc/systemd/logind.conf" ]; then
    sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' "/etc/systemd/logind.conf"
    echoscs "Disabled poweroff button"
fi

# 6. Change SDDM theme
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

# 7. VirtualBox
if pkg_installed "virtualbox" && [ -f "/sbin/vboxreload" ]; then
    echoinf "Reloading virtualbox ..."
    sudo /sbin/vboxreload
    echoscs "Reloaded virtualbox"
else
    echoerr "Please ensure virtualbox is installed and /sbin/vboxreload is executable"
fi

# 8. Replace code with visual-studio-code-bin
if pacman -Qi code 2>/dev/null | grep -q "^Name\s*:\s*code$"; then
    echoinf "Removing code ..."
    yay -R --noconfirm code;
    echoscs "Removed code ..."
else echoskp "code is already removed"; fi
if ! pkg_installed "visual-studio-code-bin"; then
    echoinf "Installing visual-studio-code-bin ..."
    yay -S visual-studio-code-bin --noconfirm code;
    echoscs "Installed visual-studio-code-bin"
else echoskp "visual-studio-code-bin is already Installed"; fi

# 9. MariaDb
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
