#!/bin/bash
set -e

# ==============================
# Colors
# ==============================
blue="\e[1;34m"
green="\e[1;32m"
yellow="\e[1;33m"
magenta="\e[1;35m"
cyan="\e[1;36m"
red="\e[1;31m"
end="\e[0m"

pause() { sleep 1; clear; }

# ==============================
# BIG MAIN BANNER
# ==============================
clear
echo -e "${blue}"
cat << "EOF"
           ___       __            ______       __  ____ __      
          / _ | ___ / /  _______ _/ _/ _ \___  / /_/ _(_) /__ ___
         / __ |(_-</ _ \/ __/ _ `/ _/ // / _ \/ __/ _/ / / -_|_-<
        /_/ |_/___/_//_/_/  \_,_/_//____/\___/\__/_//_/_/\__/___/

                          ASHRAF DOTFILES
                    End-4 Personal Overlay Installer
EOF
echo -e "${end}"
sleep 2

# ==============================
# SANITY CHECK
# ==============================
if [[ ! -d ".config" || ! -d "packages" ]]; then
  echo -e "${red}Error: Run this from inside MY-DOTFILES repo${end}"
  exit 1
fi

pause

# ==============================
# SECTION: PACMAN
# ==============================
echo -e "${magenta}"
cat << "EOF"                                    
           ___                         
          / _ \___ _______ _  ___ ____ 
         / ___/ _ `/ __/  ' \/ _ `/ _ \
        /_/   \_,_/\__/_/_/_/\_,_/_//_/

                 PACMAN PACKAGES
EOF
echo -e "${end}"

if [[ -f packages/pacman.txt ]]; then
  echo -e "${cyan}Installing pacman packages...${end}"
  sudo pacman -S --needed - < packages/pacman.txt
  echo -e "${green}Pacman packages installed ✔${end}"
else
  echo -e "${yellow}No pacman.txt found, skipping${end}"
fi

pause

# ==============================
# SECTION: AUR (yay)
# ==============================
echo -e "${magenta}"
cat << "EOF"
        __  _______  __
        \ \/ / _ \ \/ /
         \  / __ |\  / 
         /_/_/ |_|/_/  

         AUR PACKAGES
EOF
echo -e "${end}"

if [[ -f packages/aur.txt ]]; then
  if ! command -v yay &>/dev/null; then
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)

  fi

  echo -e "${cyan}Installing AUR packages via yay...${end}"
    set +e
while read -r pkg; do
  yay -S --needed --noconfirm "$pkg"
done < packages/aur.txt
set -e

  echo -e "${green}AUR packages installed ✔${end}"
else
  echo -e "${yellow}No aur.txt found, skipping${end}"
fi

pause

# ==============================
# SECTION: .CONFIG
# ==============================
echo -e "${magenta}"
cat << "EOF"
          _________  _  _______________
         / ___/ __ \/ |/ / __/  _/ ___/
        / /__/ /_/ /    / _/_/ // (_ / 
        \___/\____/_/|_/_/ /___/\___/  

                CONFIG FILES
EOF
echo -e "${end}"

mkdir -p ~/.config
cp -r .config/* ~/.config/
echo -e "${green}.config applied ✔${end}"

pause

# ==============================
# SECTION: .LOCAL/BIN
# ==============================
echo -e "${magenta}"
cat << "EOF"
          _____                              __  
         / ___/__  __ _  __ _  ___ ____  ___/ /__
        / /__/ _ \/  ' \/  ' \/ _ `/ _ \/ _  (_-<
        \___/\___/_/_/_/_/_/_/\_,_/_//_/\_,_/___/

                      LOCAL BIN
EOF
echo -e "${end}"

mkdir -p ~/.local/bin
cp -r .local/bin/* ~/.local/bin/
echo -e "${green}.local/bin applied ✔${end}"
chmod +x ~/.local/bin/*
pause

# ==============================
# SECTION: SHELL
# ==============================
echo -e "${magenta}"
cat << "EOF"
           ______       ____
          / __/ /  ___ / / /
         _\ \/ _ \/ -_) / / 
        /___/_//_/\__/_/_/  

              SHELL
EOF
echo -e "${end}"

[[ -f .zshrc ]] && cp .zshrc ~ && echo -e "${green}.zshrc applied ✔${end}"
[[ -f .bashrc ]] && cp .bashrc ~ && echo -e "${green}.bashrc applied ✔${end}"

pause

# ==============================
# FINAL
# ==============================
echo -e "${green}"
cat << "EOF"
==============================================
   ASHRAF DOTFILES APPLIED SUCCESSFULLY
==============================================

✔ End-4 preserved
✔ Packages installed
✔ Configs applied
✔ Shell ready

🔁 Reboot recommended
EOF
echo -e "${end}"
