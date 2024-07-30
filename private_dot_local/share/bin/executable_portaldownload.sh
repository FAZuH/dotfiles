#!/usr/bin/env bash

/usr/bin/rclone sync --create-empty-src-dirs --delete-after --verbose --transfers 4 \
    --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s \
    --stats-file-name-length 0 --fast-list "gdrive:8 Portal" /home/faz/Drive
