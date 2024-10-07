xrandr --output DisplayPort-0 --mode 2560x1440 --rate 143.86
xrandr --output DisplayPort-2 --left-of DisplayPort-0
xrandr --output DisplayPort-2 --pos -1x100
sh ~/.fehbg &
export EDITOR="nvim" &
export TERMINAL="st" &
#echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode &
dunst &
numlockx &
dwmblocks &
picom &
blueberry-tray &
xrdb ~/.Xresources &
/usr/lib/polkit-kde-authentication-agent-1 &
exec dwm
