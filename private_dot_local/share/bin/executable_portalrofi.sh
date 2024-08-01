#!/bin/bash

# Options to be displayed in rofi menu
# options="download\ndownload dry\nupload\nupload dry"
options="download\ndownload (dry)\nupload\nupload (dry)\ncustom upload"

# Get the user selection via rofi
selected_option=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

# Check the selected option and perform the corresponding action
if [ "$selected_option" == "download" ]; then
    kitty --detach portaldownload.sh
    echo "Done!"
    sleep 5
elif [ "$selected_option" == "upload" ]; then
    kitty --detach portalupload.sh
    echo "Done!"
    sleep 5
elif [ "$selected_option" == "download (dry)" ]; then
    kitty --detach portaldownloaddry.sh
    echo "Done!"
    sleep 5
elif [ "$selected_option" == "upload (dry)" ]; then
    kitty --detach portaluploaddry.sh
    echo "Done!"
    sleep 5
elif [ "$selected_option" == "custom upload" ]; then
    kitty --detach portalcustom.sh
    echo "Done!"
    sleep 5
fi
