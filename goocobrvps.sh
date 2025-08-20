#!/bin/bash

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White


#######################################################


echo -ne '\033c'
trap RM_HT_FOLDER SIGINT SIGQUIT SIGTSTP
echo ""
sleep 0.1
echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+"
sleep 0.1
echo -e "${Yellow}     |                                                                                                                        |"
sleep 0.1
echo -e "     |${Green}     ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó ‚Ėą‚Ėą‚Ėą‚ēó   ‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēó     ‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚Ėą‚ēó   ‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó    ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red} ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}  ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red} ‚Ėą‚Ėą${Black}‚ēó${Red}    ‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó  ${Yellow}    |"
sleep 0.1
echo -e "     |${Green}    ‚Ėą‚Ėą‚ēĒ‚ēź‚ēź‚ēź‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚Ėą‚Ėą‚ēó  ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ     ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚ēó  ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚ēź‚ēź‚ēź‚ēź‚ēĚ    ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą${Black}‚ēĎ${Red}    ‚Ėą‚Ėą${Black}‚ēĎ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēź‚ēź‚ēĚ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēź‚ēź‚ēĚ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}    ${Yellow} |"
sleep 0.1
echo -e "     |${Green}    ‚Ėą‚Ėą‚ēĎ   ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚Ėą‚Ėą‚ēó ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ     ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚Ėą‚Ėą‚ēó ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó      ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${Red}‚Ėą‚Ėą${Black}‚ēĎ   ${Red}‚Ėą‚Ėą${Black}‚ēĎ${Red}‚Ėą‚Ėą${Black}‚ēĎ ${Red}‚Ėą${Black}‚ēó ${Red}‚Ėą‚Ėą${Black}‚ēĎ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó  ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ    ${Yellow} |"
sleep 0.1
echo -e "     |${BGreen}    ‚Ėą‚Ėą‚ēĎ   ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ‚ēö‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ     ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ‚ēö‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚ēź‚ēź‚ēĚ      ${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĎ   ${Red}‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĎ‚ēö‚ēź‚ēź‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēĚ  ${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēó    ${Yellow} |"
sleep 0.1
echo -e "     |${BGreen}    ‚ēö‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēĒ‚ēĚ‚Ėą‚Ėą‚ēĎ ‚ēö‚Ėą‚Ėą‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ ‚ēö‚Ėą‚Ėą‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó    ${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${BRed}‚Ėą‚Ėą${Black}‚ēĎ${BRed}  ‚Ėą‚Ėą${Black}‚ēĎ‚ēö${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ‚ēö${BRed}‚Ėą‚Ėą‚Ėą${Black}‚ēĒ${BRed}‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĎ  ${BRed}‚Ėą‚Ėą${Black}‚ēĎ    ${Yellow} |"
sleep 0.1
echo -e "     |${Green}     ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēĚ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ    ${Black}‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēĚ ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ  ‚ēö‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēĚ ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēĚ ${Yellow}    |"
sleep 0.1
echo -e "     |                                                                                                               ${BCyan} BETA${Yellow}    |"
sleep 0.1
echo -e "     |                                                                                                                        |"
sleep 0.1
echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+${Yellow}"
sleep 0.1
echo -e "                                     |${BRed} Online Browser ${BYellow}by${BGreen} Hamza Hammouch${Cyan} powerd by${BPurple} linuxserver${Yellow} |"
sleep 0.1
echo -e "                                     ${Cyan}+${Yellow}--------------------------------------------------------${Cyan}+"
sleep 0.1

#######################################################

# دالة للتحقق من تثبيت Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${Red}Docker غير مثبت. يرجى تثبيت Docker أولاً.${White}"
        exit 1
    fi
}

# دالة للتحقق من وجود حاوية بنفس الاسم
check_container_exists() {
    local container_name=$1
    if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
        echo -e "${Red}تحذير: حاوية Docker باسم '${container_name}' موجودة بالفعل.${White}"
        read -p "هل تريد الاستمرار واستبدال الحاوية الحالية؟ (y/n): " replace
        if [[ ! $replace =~ ^[Yy]$ ]]; then
            echo "تم الإلغاء."
            exit 1
        fi
        echo -e "${Yellow}إزالة الحاوية الموجودة...${White}"
        docker rm -f $container_name
    fi
}

# قسم المتصفحات
show_browser_menu() {
    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Browser Name                       ${White}   |"
    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo -e "${White}     | ${Red}[${Yellow}01${Red}]${White} |$Green Install Chromium${White}                                           |"
    echo -e "${White}     | ${Red}[${Yellow}02${Red}]${White} |$Green Install Firefox${White}                                            |"
    echo -e "${White}     | ${Red}[${Yellow}03${Red}]${White} |$Green Install Opera${White}                                              |"
    echo -e "${White}     | ${Red}[${Yellow}04${Red}]${White} |$Green Install Mullvad Browser${White}                                    |"
    echo -e "${White}     | ${Red}[${Yellow}05${Red}]${White} |$Green Install Brave Browser${White}                                      |"
    echo -e "${White}     | ${Red}[${Yellow}06${Red}]${White} |$Green Install Vivaldi Browser${White}                                    |"
    echo -e "${White}     | ${Red}[${Yellow}07${Red}]${White} |$Green Install Microsoft Edge${White}                                     |"
    echo -e "${White}     | ${Red}[${Yellow}08${Red}]${White} |$Green Install Tor Browser${White}                                        |"
    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo ""
    echo -e -n "$White    ${Red} [${Cyan}!Note:${Red}]$White If your choice is Chromium type $Green 1${White} not ${Red}01$White and the same principle applies to other browsers "
    echo ""
    echo ""
    echo -e -n "$White    ${Red} [${Cyan}!${Red}]$White Type the$BRed ID$White "
    read -p "of your choice : " choice
    
    check_docker
    
    case $choice in
        1)
            echo "Installing Chromium..."
            check_container_exists "chromium"
            docker run -d \
                --name=chromium \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /chromium:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/chromium:latest
            ;;
        2)
            echo "Installing Firefox..."
            check_container_exists "firefox"
            docker run -d \
                --name=firefox \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /firefox:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/firefox:latest
            ;;
        3)
            echo "Installing Opera..."
            check_container_exists "opera"
            docker run -d \
                --name=opera \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /opera:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/opera:latest
            ;;
        4)
            echo "Installing Mullvad Browser..."
            check_container_exists "mullvad-browser"
            docker run -d \
                --name=mullvad-browser \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /mullvad-browser:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/mullvad-browser:latest
            ;;
        5)
            echo "Installing Brave Browser..."
            check_container_exists "brave"
            docker run -d \
                --name=brave \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /brave:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/brave:latest
            ;;
        6)
            echo "Installing Vivaldi Browser..."
            check_container_exists "vivaldi"
            docker run -d \
                --name=vivaldi \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /vivaldi:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/vivaldi:latest
            ;;
        7)
            echo "Installing Microsoft Edge..."
            check_container_exists "edge"
            docker run -d \
                --name=edge \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /edge:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/edge:latest
            ;;
        8)
            echo "Installing Tor Browser..."
            check_container_exists "tor-browser"
            docker run -d \
                --name=tor-browser \
                --security-opt seccomp=unconfined \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /tor-browser:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/tor-browser:latest
            ;;
        *)
            echo "Invalid choice. Please enter a valid option."
            exit 1
            ;;
    esac
}

# قسم الأجهزة المكتبية
show_desktop_menu() {
    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Desktop Environment                  ${White}   |"
    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo -e "${White}     | ${Red}[${Yellow}01${Red}]${White} |$Green Install XFCE Desktop${White}                                      |"
    echo -e "${White}     | ${Red}[${Yellow}02${Red}]${White} |$Green Install GNOME Desktop${White}                                     |"
    echo -e "${White}     | ${Red}[${Yellow}03${Red}]${White} |$Green Install KDE Plasma Desktop${White}                                |"
    echo -e "${White}     | ${Red}[${Yellow}04${Red}]${White} |$Green Install MATE Desktop${White}                                      |"
    echo -e "${White}     | ${Red}[${Yellow}05${Red}]${White} |$Green Install Cinnamon Desktop${White}                                  |"
    echo -e "${White}     | ${Red}[${Yellow}06${Red}]${White} |$Green Install LXQt Desktop${White}                                      |"
    echo -e "${White}     | ${Red}[${Yellow}07${Red}]${White} |$Green Install LXDE Desktop${White}                                      |"
    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo ""
    echo -e -n "$White    ${Red} [${Cyan}!${Red}]$White Type the$BRed ID$White "
    read -p "of your choice : " choice
    
    check_docker
    
    case $choice in
        1)
            echo "Installing XFCE Desktop..."
            check_container_exists "xfce-desktop"
            docker run -d \
                --name=xfce-desktop \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /xfce-desktop:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/webtop:ubuntu-xfce
            ;;
        2)
            echo "Installing GNOME Desktop..."
            check_container_exists "gnome-desktop"
            docker run -d \
                --name=gnome-desktop \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /gnome-desktop:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/webtop:ubuntu-gnome
            ;;
        3)
            echo "Installing KDE Plasma Desktop..."
            check_container_exists "kde-desktop"
            docker run -d \
                --name=kde-desktop \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /kde-desktop:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/webtop:ubuntu-kde
            ;;
        4)
            echo "Installing MATE Desktop..."
            check_container_exists "mate-desktop"
            docker run -d \
                --name=mate-desktop \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /mate-desktop:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/webtop:ubuntu-mate
            ;;
        5)
            echo "Installing Cinnamon Desktop..."
            check_container_exists "cinnamon-desktop"
            docker run -d \
                --name=cinnamon-desktop \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /cinnamon-desktop:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/webtop:ubuntu-cinnamon
            ;;
        6)
            echo "Installing LXQt Desktop..."
            check_container_exists "lxqt-desktop"
            docker run -d \
                --name=lxqt-desktop \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /lxqt-desktop:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/webtop:ubuntu-lxqt
            ;;
        7)
            echo "Installing LXDE Desktop..."
            check_container_exists "lxde-desktop"
            docker run -d \
                --name=lxde-desktop \
                -e PUID=1000 \
                -e PGID=1000 \
                -e TZ=Etc/UTC \
                -p 3000:3000 \
                -p 3001:3001 \
                -v /lxde-desktop:/config \
                --shm-size="7gb" \
                --restart unless-stopped \
                ghcr.io/linuxserver/webtop:ubuntu-lxde
            ;;
        *)
            echo "Invalid choice. Please enter a valid option."
            exit 1
            ;;
    esac
}

# القائمة الرئيسية
echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Category                            ${White}   |"
echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo -e "${White}     | ${Red}[${Yellow}01${Red}]${White} |$Green Browsers Installation${White}                                    |"
echo -e "${White}     | ${Red}[${Yellow}02${Red}]${White} |$Green Desktop Environments Installation${White}                       |"
echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo ""
echo -e -n "$White    ${Red} [${Cyan}!${Red}]$White Type the$BRed ID$White "
read -p "of your choice : " main_choice

case $main_choice in
    1)
        show_browser_menu
        ;;
    2)
        show_desktop_menu
        ;;
    *)
        echo "Invalid choice. Please enter 1 or 2."
        exit 1
        ;;
esac

#######################################################

clear
echo ""
sleep 0.1
echo -e -n "$White    ${Red} [${Green} ‚úĒ ${Red}]$White Installation completed successfully ( ‚ÄĘŐÄ ŌČ ‚ÄĘŐĀ )‚úß"
sleep 0.1
echo ""
sleep 0.1
echo ""
sleep 0.1
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚ĘÄ‚£†‚£ī‚£ĺ‚£Ņ‚£Ņ‚£Ņ‚£∂‚£Ą‚°Ä‚†Ä"
sleep 0.1
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚£Ä‚£§‚£ĺ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£∑‚°Ą"
sleep 0.1
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚ĘÄ‚£†‚£ī‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£∑"
sleep 0.1
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚£Ä‚°§${Blue}‚†ĺ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚°ü‚†Č‚†ô‚£Ņ‚£Ņ‚°Ņ"
sleep 0.1
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚ĘÄ‚£†‚†∂‚†õ‚†Ā‚†Ä‚†Ä${Blue}‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£ß‚£Ą‚£†‚£Ņ‚°Ņ‚†Ā"
sleep 0.1
echo -e "    ${Red} ‚†Ä‚†Ä‚£Ä‚°§‚†ě‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚†ł‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚°Ņ‚†ü‚†č‚†Ä‚†Ä"
sleep 0.1
echo -e "    ${Red} ‚ĘÄ‚°ĺ‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚†ô‚ĘŅ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚†Ņ‚†õ‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
sleep 0.1
echo -e "    ${Red} ‚£ĺ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚ĘÄ‚£†‚£§‚°Ä${Blue}‚†ô‚ĘŅ‚£Ņ‚°Ņ‚†ü‚†č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
sleep 0.1
echo -e "    ${Red} ‚£Ņ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚£†‚£ī‚£ĺ‚°Ņ‚†ü‚Ęč‚£§‚†∂‚†õ‚†Ā‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
sleep 0.1
echo -e "    ${Red} ‚†ė‚£ß‚°Ä‚†Ä‚Ęį‚£Ņ‚£∂‚£Ņ‚†Ņ‚†õ‚£©‚°ī‚†ě‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
sleep 0.1
echo -e "    ${Red} ‚†Ä‚†ą‚†õ‚†¶‚£§‚£§‚£§‚°§‚†Ė‚†č‚†Ā‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
sleep 0.1
echo -e "    ${White}"
sleep 0.1
echo ""
