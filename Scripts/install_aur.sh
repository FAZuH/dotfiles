#!/usr/bin/env bash
#|---/ /+-------------------------------------------+---/ /|#
#|--/ /-| Script to install aur helper, yay or paru |--/ /-|#
#|-/ /--| Prasanth Rangan                           |-/ /--|#
#|/ /---+-------------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")

if ! source "${scrDir}/global_fn.sh"; then
    echo -e "\033[0;31m[ERROR]\033[0m unable to source global_fn.sh..."
    exit 1
fi

if chk_list "aurhlpr" "${aurList[@]}"; then
    echo -e "\033[0;32m[AUR]\033[0m detected // ${aurhlpr}"
    exit 0
fi

aurhlpr="${1:-yay}"

if [ -d "$HOME/Clone" ]; then
    echoinf "~/Clone directory exists..."
    rm -rf "$HOME/Clone/${aurhlpr}"
else
    mkdir "$HOME/Clone"
    echo -e "[Desktop Entry]\nIcon=default-folder-git" > "$HOME/Clone/.directory"
    echoinf "~/Clone directory created..."
fi

if pkg_installed git; then
    git clone "https://aur.archlinux.org/${aurhlpr}.git" "$HOME/Clone/${aurhlpr}"
else
    echoerr "git dependency is not installed..."
    exit 1
fi

cd "$HOME/Clone/${aurhlpr}"
makepkg ${use_default} -si

if [ $? -eq 0 ]; then
    echoscs "${aurhlpr} aur helper installed..."
    exit 0
else
    echoerr "${aurhlpr} installation failed..."
    exit 1
fi
