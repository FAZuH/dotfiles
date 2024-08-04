#!/usr/bin/env bash
#|---/ /+------------------+---/ /|#
#|--/ /-| Global functions |--/ /-|#
#|-/ /--| Prasanth Rangan  |-/ /--|#
#|/ /---+------------------+/ /---|#

set -e

scrDir="$(dirname "$(realpath "$0")")"
cloneDir="$(dirname "${scrDir}")"
aurList=(yay paru)
shlList=(zsh fish)

pkg_installed() {
    # Check if a package is installed using pacman.
    #
    # Args:
    #     PkgIn (str): The name of the package to check.
    #
    # Returns:
    #     int: 0 if the package is installed, 1 otherwise.
    #
    # Example:
    #     if pkg_installed "nano"; then
    #         echo "Nano is installed."
    #     else
    #         echo "Nano is not installed."
    #     fi
    local pkg
    local all_installed=0

    for pkg in "$@"; do
        if ! pacman -Qi "$pkg" &> /dev/null; then
            echo "$pkg is not installed."
            all_installed=1
        fi
    done

    return $all_installed
}

chk_list() {
    # Check if any package in the provided list is installed, and set a variable with the name of the first installed package.
    #
    # Args:
    #     vrType (str): The name of the variable to be set with the name of the first installed package.
    #     inList (list of str): A list of package names to check.
    #
    # Returns:
    #     int: 0 if any package in the list is installed, 1 otherwise.
    #
    # Side Effects:
    #     Sets and exports a variable with the name provided in `vrType` to the name of the first installed package.
    vrType="$1"
    local inList=("${@:2}")
    for pkg in "${inList[@]}"; do
        if pkg_installed "${pkg}"; then
            printf -v "${vrType}" "%s" "${pkg}"
            export "${vrType}"
            return 0
        fi
    done
    return 1
}


pkg_available() {
    # Check if a package is available in the official repositories using pacman.
    #
    # Args:
    #     PkgIn (str): The name of the package to check.
    #
    # Returns:
    #     int: 0 if the package is available, 1 otherwise.
    #
    # Example:
    #     if pkg_available "nano"; then
    #         echo "Nano is available in the official repositories."
    #     else
    #         echo "Nano is not available in the official repositories."
    #     fi
    local PkgIn=$1

    if pacman -Si "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

aur_available() {
    # Check if a package is available in the AUR (Arch User Repository) using an AUR helper.
    #
    # Args:
    #     PkgIn (str): The name of the package to check.
    #
    # Returns:
    #     int: 0 if the package is available, 1 otherwise.
    #
    # Example:
    #     if aur_available "yay"; then
    #         echo "Yay is available in the AUR."
    #     else
    #         echo "Yay is not available in the AUR."
    #     fi
    local PkgIn=$1

    if ${aurhlpr} -Si "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

nvidia_detect() {
    # Detect NVIDIA GPUs in the system.
    #
    # Options:
    #   --verbose: Print detected GPUs.
    #   --drivers: Print driver information.
    #
    # Returns:
    #     int: 0 if an NVIDIA GPU is detected or if the verbose/drivers mode completes successfully, 1 otherwise.
    #
    # Example:
    #     nvidia_detect --verbose
    #     nvidia_detect --drivers
    #     if nvidia_detect; then
    #         echo "NVIDIA GPU detected."
    #     else
    #         echo "No NVIDIA GPU detected."
    #     fi
    readarray -t dGPU < <(lspci -k | grep -E "(VGA|3D)" | awk -F ': ' '{print $NF}')
    if [ "${1}" == "--verbose" ]; then
        for indx in "${!dGPU[@]}"; do
            echo -e "\033[0;32m[gpu$indx]\033[0m detected // ${dGPU[indx]}"
        done
        return 0
    fi
    if [ "${1}" == "--drivers" ]; then
        while read -r -d ' ' nvcode ; do
            awk -F '|' -v nvc="${nvcode}" 'substr(nvc,1,length($3)) == $3 {split(FILENAME,driver,"/"); print driver[length(driver)],"\nnvidia-utils"}' "${scrDir}"/.nvidia/nvidia*dkms
        done <<< "${dGPU[@]}"
        return 0
    fi
    if grep -iq nvidia <<< "${dGPU[@]}"; then
        return 0
    else
        return 1
    fi
}

prompt_timer() {
    # Prompt the user for input with a countdown timer.
    #
    # Args:
    #     timsec (int): The number of seconds to wait for input.
    #     msg (str): The message to display to the user.
    #
    # Side Effects:
    #     Sets the environment variable `promptIn` with the user's input if provided within the time limit.
    #
    # Example:
    #     prompt_timer 30 "Enter your choice"
    #     echo "User entered: $promptIn"
    set +e
    unset promptIn
    local timsec=$1
    local msg=$2
    while [[ ${timsec} -ge 0 ]]; do
        echo -ne "\r :: ${msg} (${timsec}s) : "
        read -t 1 -n 1 promptIn
        [ $? -eq 0 ] && break
        ((timsec--))
    done
    export promptIn
    echo ""
    set -e
}


#---------#
# Logging #
#---------#
#
LOG_LEVEL_SKIP=1
LOG_LEVEL_INFO=2
LOG_LEVEL_WARN=3
LOG_LEVEL_ERROR=4
LOG_LEVEL_SUCCESS=5

CURRENT_LOG_LEVEL=$LOG_LEVEL_WARN

_checkloglevel() {
    if [ "$CURRENT_LOG_LEVEL" -ge "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Function to log skip messages
echoskp() {
    local message="$1"
    _checkloglevel "$LOG_LEVEL_SKIP" && echo -e "\033[0;33m[SKIP]\033[0m $message"
}

# Function to log informational messages
echoinf() {
    local message="$1"
    _checkloglevel "$LOG_LEVEL_INFO" && echo -e "\033[0;34m[INFO]\033[0m $message"
}

# Function to log warning messages
echowrn() {
    local message="$1"
    _checkloglevel "$LOG_LEVEL_WARN" && echo -e "\033[0;33m[WARNING]\033[0m $message"
}

# Function to log error messages
echoerr() {
    local message="$1"
    _checkloglevel "$LOG_LEVEL_ERROR" && echo -e "\033[0;31m[ERROR]\033[0m $message"
}

# Function to log success messages
echoscs() {
    local message="$1"
    _checkloglevel "$LOG_LEVEL_SUCCESS" && echo -e "\033[0;32m[SUCCESS]\033[0m $message"
}
