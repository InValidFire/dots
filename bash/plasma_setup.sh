echo "Plasma DE detected, installing Plasma configuration"

# set window modifier key to Alt (drag window when Alt is held)
kwriteconfig5 --file ~/.config/kwinrc --group MouseBindings --key CommandAllKey Alt

# download Dracula theme
wget "https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1585425749/Dracula.tar.xz?response-content-disposition=attachment%3B%2520Dracula.tar.xz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20240516%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240516T062040Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=e1b9199269710bf27ac9b5d0e122889a87b9dd5eec0905176a21c3dbec2074cb" -P ~/.local/share/plasma/desktoptheme/ -O dracula.tar.xz
tar xvf ~/.local/share/plasma/desktoptheme/dracula.tar.xz --directory=~/.local/share/plasma/desktoptheme
