#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install pkgs from input list |--/ /-|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
if ! source "${scrDir}/global_fn.sh"; then
    echo -e "\033[0;31m[ERROR]\033[0m unable to source global_fn.sh..."
    exit 1
fi

chk_list "aurhlpr" "${aurList[@]}"
listPkg="${1:-"${scrDir}/list_apps.lst"}"
archPkg=()
aurhPkg=()
ofs=$IFS
IFS='|'

while read -r pkg deps; do
    pkg="${pkg// /}"
    if [ -z "${pkg}" ]; then
        continue
    fi

    if [ ! -z "${deps}" ]; then
        deps="${deps%"${deps##*[![:space:]]}"}"
        while read -r cdep; do
            pass=$(cut -d '#' -f 1 "${listPkg}" | awk -F '|' -v chk="${cdep}" '{if($1 == chk) {print 1;exit}}')
            if [ -z "${pass}" ]; then
                if pkg_installed "${cdep}"; then
                    pass=1
                else
                    break
                fi
            fi
        done < <(echo "${deps}" | xargs -n1)

        if [[ ${pass} -ne 1 ]]; then
            echoskp "${pkg} is missing (${deps}) dependency..."
            continue
        fi
    fi

    if pkg_installed "${pkg}"; then
        echoskp "${pkg} is already installed..."
    elif pkg_available "${pkg}"; then
        repo=$(pacman -Si "${pkg}" | awk -F ': ' '/Repository / {print $2}')
        echo -e "\033[0;32m[${repo}]\033[0m queueing ${pkg} from official arch repo..."
        archPkg+=("${pkg}")
    elif aur_available "${pkg}"; then
        echo -e "\033[0;34m[AUR]\033[0m queueing ${pkg} from arch user repo..."
        aurhPkg+=("${pkg}")
    else
        echoerr "unknown package ${pkg}..."
    fi
done < <(cut -d '#' -f 1 "${listPkg}")

IFS=${ofs}

if [[ ${#archPkg[@]} -gt 0 ]]; then
    sudo pacman ${use_default} -S --noconfirm "${archPkg[@]}"
fi

if [[ ${#aurhPkg[@]} -gt 0 ]]; then
    "${aurhlpr}" ${use_default} -S --noconfirm "${aurhPkg[@]}"
fi
