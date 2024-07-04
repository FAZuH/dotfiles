sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' /etc/systemd/logind.conf

mkdir -p ~/.local/share/applications 

echo -e "[Desktop Entry]\nVersion=1.0\nName=LINE\nComment=Line Messanger application\nExec=chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html\nIcon=/home/faz/.config/chromium/Default/Extensions/ophjlpahpchlmihnnnihgmmeilfjmjjc/3.3.0_0/line_logo_128x128_on.png\nTerminal=false\nType=Application" | tee ~/.local/share/applications/line.desktop

echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub

sudo grub-mkconfig -o /boot/grub/grub.cfg
