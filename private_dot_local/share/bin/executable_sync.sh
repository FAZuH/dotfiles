#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
confPath="$scrDir/sync.conf"


_checkHealth() {
    if ! source "${scrDir}/global_fn.sh"; then
        echo -e "\033[0;31m[ERROR]\033[0m unable to source global_fn.sh..."
        read -r
        exit 1
    fi
    if [ ! -f "$confPath" ]; then
        echoerr "file $confPath not found"
        read -r
        exit 1
    fi
}

_rsync() {
    local="$1"
    remote="$2"
    method="$3"
    isDry="$4"
    # method arg validation
    if [[ "$method" != "down" ]] && [[ "$method" != "up" ]]; then
        echoerr "Invalid method $method. Use 'down' or 'up'"
        exit 1 
    fi
    # isDry arg validation
    if [[ "$isDry" -ne 0 ]] && [[ "$isDry" -ne 1 ]]; then
        echoerr "Invalid isDry '$isDry'. Use 'down' or 'up'"
        exit 1 
    fi
    # determine sync source & destination
    if [[ "$method" == "down" ]]; then
        source="$remote"
        destination="$local"
    elif [[ "$method" == "up" ]]; then
        source="$local"
        destination="$remote"
    fi
    # determine options
    if [ "$isDry" -eq 0 ]; then
        extraOptions=""
    elif [ "$isDry" -eq 1 ]; then
        extraOptions="--dry-run"
    fi
    # execute command
    echo ""
    echoinf "-------------------------------------------------"
    echoinf ""
    echoinf "Synchronizing:"
    echoinf "    - Source: $source"
    echoinf "    - Destination: $destination"
    echoinf "    - Dry Run: $isDry"
    echoinf ""
    echoinf "-------------------------------------------------"
    echo ""
    rclone sync "$source" "$destination" --fix-case --create-empty-src-dirs --delete-after --verbose --transfers 4 \
        --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s \
        --stats-file-name-length 0 --fast-list --progress $extraOptions
}

_run_rsync() {
    method="$1"
    isDry="$2"
    syncCount=0
    while IFS= read -r line; do
        if [[ -z "$line" || "$line" =~ ^# ]]; then
            continue
        fi
        key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
        value=$(echo "$line" | cut -d'=' -f2- | sed 's/^"//;s/"$//')
        if [ "$key" = "remote" ]; then
            remote="$value"
        elif [ "$key" = "local" ]; then
            local=$(eval echo "$value")
            mkdir -p "$local"
        elif [ "$key" = "method" ] && [ "$value" = "$method" ]; then
            _rsync "$local" "$remote" "$method" "$isDry"
            syncCount="$((syncCount+1))"
        fi
    done < "$confPath"
    echo ""
    echoscs "-------------------------------------------------"
    echoscs ""
    echoscs "Synchronized $syncCount items"
    echoscs ""
    echoscs "-------------------------------------------------"
    echo ""
    echoinf "Press any key to continue"
    read -n 1
    clear
}


main() {
    _checkHealth
    options=(
        "download"
        "upload"
        "download (dry)"
        "upload (dry)"
        "quit"
    )

    while true; do
        selected_option=$(printf "%s\n" "${options[@]}" | fzf --reverse --prompt "Select an option: ")
        case "$selected_option" in
            "download") _run_rsync "down" 0 ;;
            "download (dry)") _run_rsync "down" 1 ;;
            "upload") _run_rsync "up" 0 ;;
            "upload (dry)") _run_rsync "up" 1 ;;
            "quit") break ;;
            *) echoerr "Invalid option. Please try again." ;;
        esac
    done
}

main
