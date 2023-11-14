#!/bin/bash

if command -v sudo >> /dev/null; then
    THEME_DIR="/run/media/$USER/Ventoy"
fi

read -p "*** Enter Menu font size in px ( preferrably between 15 to 30): " fontsize
printf "\nPlease Make sure ventoy is mounted as system partition and run lsblk to see mount point\n"

if [[ $(id -u) != "0" ]]; then
    printf "\n\nWarning: Current user does not have root perms, make sure you can read/write the mount point\n\n"
fi

if command -v sudo >> /dev/null; then
    read -p "*** Enter Mount Directory: [/run/media/$USER/Ventoy] " THEME_DIR
else
    read -p "*** Enter Mount Directory: [/run/media/$USER/Ventoy] " THEME_DIR
fi

if [ ! -d $THEME_DIR ]; then
    echo "The entered directory doesn't exist"
    exit
fi

THEME_DIR="$THEME_DIR/ventoy/themes/grub_gtg"
mkdir -p $THEME_DIR

printf "\n - Making fonts...\n"
if command -v grub-mkfont >> /dev/null; then
	grub-mkfont -s $fontsize -b ./assets/fonts/BankGothic.ttf -o $THEME_DIR/bankgothic.pf2
elif command -v grub2-mkfont >> /dev/null; then
	grub2-mkfont -s $fontsize -b ./assets/fonts/BankGothic.ttf -o $THEME_DIR/bankgothic.pf2
else
	printf "\n - grub font maker doesn't exist using the default font\n"
    cp ./assets/fonts/bankgothic.pf2 $THEME_DIR/bankgothic.pf2
fi

printf "\n - Copying assets...\n"
cp ./assets/images/ventoy_background.png $THEME_DIR/background.png
cp ./assets/menu/menu_*.png $THEME_DIR/
cp ./assets/selection/select_*.png $THEME_DIR/
cp ./assets/scrollbar/scrollbar_thumb_c.png $THEME_DIR/

printf "\n - Copying theme.txt...\n"
cp ./assets/ventoy_theme.txt $THEME_DIR/theme.txt

if [ -f $THEME_DIR/../../ventoy.json ]; then
    printf "\n - Backing up old ventoy.json...\n"
    mv $THEME_DIR/../../ventoy.json $THEME_DIR/../../ventoy.old.json
fi

printf "\n - Copying ventoy.json...\n"
cp ./assets/ventoy.json $THEME_DIR/../../ventoy.json
echo "Make sure it is in the right directory"
