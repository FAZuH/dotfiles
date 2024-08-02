#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
confPath="${scrDir}/sync.conf"


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
    # determine sync source & destination
    if [[ "$method" == "down" ]]; then
        source="$remote"
        destination="$local"
    elif [[ "$method" == "up" ]]; then
        source="$local"
        destination="$remote"
    else
        echoerr "Invalid method $method. Use 'down' or 'up'"
        exit 1 
    fi
    # determine options
    extraOptions=""
    isDry="False"
    if [[ "$*" == *--dry* ]]; then
        extraOptions+="--dry-run"
        isDry="True"
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
    syncCount=0
    exec 3< "$confPath"
    while IFS= read -r line <&3; do
        if [[ -z "$line" || "$line" =~ ^# ]]; then
            continue
        fi
        key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
        value=$(echo "$line" | cut -d'=' -f2- | sed 's/^"//;s/"$//')
        case "$key" in
            "remote")
                remote="$value"
                ;;
            "local")
                local=$(eval echo "$value")
                mkdir -p "$local"
                ;;
            "method")
                if [[ "$value" != *"$method" ]]; then
                    continue
                fi
                if [[ "$value" == interactive* ]]; then
                    if [[ "$*" != *--interactive* ]]; then
                        continue
                    fi
                    read -rp "Synchronize $method for $local and $remote? [y/n]: " isContinue
                    if [[ "$isContinue" != "y" ]]; then
                        echoskp "Skipped synchonizing $method for $local and $remote"
                        continue
                    fi
                fi
                if [[ -z "$local" ]]; then
                    echoerr "Error: Value with key 'local' is an empty string"
                    exit 1
                fi
                if [[ -z "$remote" ]]; then
                    echoerr "Error: Value with key 'remote' is an empty string"
                    exit 1
                fi
                _rsync "$local" "$remote" "$method" "${@:2}"
                syncCount="$((syncCount+1))"
                ;;
            *)
                echoerr "Invalid key on $confPath: $key"
                ;;
        esac
    done
    exec 3<&-
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
        "download (interactive)"
        "download (dry, interactive)"
        "upload (dry)"
        "upload (interactive)"
        "upload (dry, interactive)"
        "quit"
    )
    while true; do
        selected_option=$(printf "%s\n" "${options[@]}" | fzf --reverse --prompt "Select an option: ")
        case "$selected_option" in
            "download")                     _run_rsync "down" ;;
            "download (dry)")               _run_rsync "down" --dry ;;
            "download (interactive)")       _run_rsync "down" --interactive ;;
            "download (dry, interactive)")  _run_rsync "down" --dry --interactive ;;
            "upload")                       _run_rsync "up" ;;
            "upload (dry)")                 _run_rsync "up" --dry ;;
            "upload (interactive)")         _run_rsync "up" --interactive ;;
            "upload (dry, interactive)")    _run_rsync "up" --dry --interactive ;;
            "quit") break ;;
            *) echoerr "Invalid option. Please try again." ;;
        esac
    done
}

main
