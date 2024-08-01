#!/usr/bin/zsh

zmodload zsh/parameter
autoload +X _complete
functions[_original_complete]=$functions[_complete]
_complete () {
  unset 'compstate[vared]'
  _original_complete "$@"
}

srcpath="Enter source path: "
vared srcpath

srcpath=$(echo "$srcpath" | sed 's/.*: //')

if [ ! -f "$srcpath" ]; then
    echo "Error: Invalid path ($srcpath)"
    read
    exit 1
fi

echo "Copying $srcpath to portal..."

/usr/bin/rclone copy --create-empty-src-dirs --verbose --transfers 4 --progress \
    --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s \
    --stats-file-name-length 0 --fast-list "$srcpath" "gdrive:8 Portal"

read
