#!/usr/bin/env bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#


# Options:
#     --install: Install apps listed on list_apps only.
#     --heavy: Install apps listed on list_apps_heavy only.

cat << "EOF"

-------------------------------------------------
        .
       / \    
      /^  \   
     /  _  \  
    /  | | ~\ 
   /.-'   '-.\

-------------------------------------------------

EOF

# import variables and functions
scrDir=$(dirname "$(realpath "$0")")

if ! source "global_fn.sh"; then
    echo -e "\033[0;31m[ERROR]\033[0m unable to source global_fn.sh..."
    exit 1
fi
export CURRENT_LOG_LEVEL=0

if [ "$1" == "--heavy" ]; then
    if ! chk_list "aurhlpr" "${aurList[@]}"; then
        echoerr "Can't find aur helper yay or paru"
        exit 1
    fi
    "${scrDir}/install_pkg.sh" "${scrDir}/list_apps_heavy.lst"
    exit 0
fi

if [ "$1" == "--install" ]; then
    if ! chk_list "aurhlpr" "${aurList[@]}"; then
        echoerr "Can't find aur helper yay or paru"
        exit 1
    fi
    "${scrDir}/install_pkg.sh" "${scrDir}/list_apps.lst"
    exit 0
fi
"${scrDir}/install_pkg.sh" "${scrDir}/install_pkg.lst"


cat << "EOF"

-------------------------------------------------
                _         _       _ _
 ___ ___ ___   |_|___ ___| |_ ___| | |
| . |  _| -_|  | |   |_ -|  _| .'| | |
|  _|_| |___|  |_|_|_|___|_| |__,|_|_|
|_|

-------------------------------------------------

EOF

# pre-install script
"${scrDir}/install_pre.sh"

cat << "EOF"

-------------------------------------------------
 _         _       _ _ _
|_|___ ___| |_ ___| | |_|___ ___
| |   |_ -|  _| .'| | | |   | . |
|_|_|_|___|_| |__,|_|_|_|_|_|_  |
                            |___|

-------------------------------------------------

EOF

#----------------------#
# prepare package list #
#----------------------#
shift $((OPTIND - 1))
cust_pkg=$1
cp "${scrDir}/list_apps.lst" "${scrDir}/install_pkg.lst"

if [ -f "${cust_pkg}" ] && [ -n "${cust_pkg}" ]; then
    cat "${cust_pkg}" >> "${scrDir}/install_pkg.lst"
fi

#--------------------------------#
# add nvidia drivers to the list #
#--------------------------------#
if nvidia_detect; then
    cat /usr/lib/modules/*/pkgbase | while read -r krnl; do
        echo "${krnl}-headers" >> "${scrDir}/install_pkg.lst"
    done
    nvidia_detect --drivers >> "${scrDir}/install_pkg.lst"
fi

nvidia_detect --verbose

#----------------#
# get user prefs #
#----------------#
if ! chk_list "aurhlpr" "${aurList[@]}"; then
    echo -e "Available aur helpers:\n[1] yay\n[2] paru"
    prompt_timer 120 "Enter option number"

    case "${promptIn}" in
        1) export getAur="yay" ;;
        2) export getAur="paru" ;;
        *) echoerr "...Invalid option selected..." ; exit 1 ;;
    esac
fi

if ! chk_list "myShell" "${shlList[@]}"; then
    echo -e "Select shell:\n[1] zsh\n[2] fish"
    prompt_timer 120 "Enter option number"

    case "${promptIn}" in
        1) export myShell="zsh" ;;
        2) export myShell="fish" ;;
        *) echoerr "...Invalid option selected..." ; exit 1 ;;
    esac
    echo "${myShell}" >> "${scrDir}/install_pkg.lst"
fi

#--------------------------------#
# install packages from the list #
#--------------------------------#
"${scrDir}/install_aur.sh" "${getAur}" 2>&1
"${scrDir}/install_pkg.sh" "${scrDir}/install_pkg.lst"
rm "${scrDir}/install_pkg.lst"

cat << "EOF"

-------------------------------------------------
             _      _         _       _ _
 ___ ___ ___| |_   |_|___ ___| |_ ___| | |
| . | . |_ -|  _|  | |   |_ -|  _| .'| | |
|  _|___|___|_|    |_|_|_|___|_| |__,|_|_|
|_|

-------------------------------------------------

EOF

# post-install script
"${scrDir}/install_pst.sh"
