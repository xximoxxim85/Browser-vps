#!/bin/bash

# الألوان
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# الألوان الجريئة
BBlack='\e[1;30m'       # Bold Black
BRed='\e[1;31m'         # Bold Red
BGreen='\e[1;32m'       # Bold Green
BYellow='\e[1;33m'      # Bold Yellow
BBlue='\e[1;34m'        # Bold Blue
BPurple='\e[1;35m'      # Bold Purple
BCyan='\e[1;36m'        # Bold Cyan
BWhite='\e[1;37m'       # Bold White


#######################################################


echo -ne '\033c'
trap RM_HT_FOLDER SIGINT SIGQUIT SIGTSTP
echo ""
sleep 0.1
echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+"
sleep 0.1
echo -e "${Yellow}     |                                                                                                                        |"
sleep 0.1
echo -e "     |${Green}     ██████╗ ███╗   ██╗██╗     ██╗███╗   ██╗███████╗    ${Red}██████${Black}╗${Red} ██████${Black}╗${Red}  ██████${Black}╗${Red} ██${Black}╗${Red}    ██${Black}╗${Red}███████${Black}╗${Red}███████${Black}╗${Red}██████${Black}╗  ${Yellow}    |"
sleep 0.1
echo -e "     |${Green}    ██╔═══██╗████╗  ██║██║     ██║████╗  ██║██╔════╝    ${Red}██${Black}╔══${Red}██${Black}╗${Red}██${Black}╔══${Red}██${Black}╗${Red}██${Black}╔═══${Red}██${Black}╗${Red}██${Black}║${Red}    ██${Black}║${Red}██${Black}╔════╝${Red}██${Black}╔════╝${Red}██${Black}╔══${Red}██${Black}╗${Red}    ${Yellow} |"
sleep 0.1
echo -e "     |${Green}    ██║   ██║██╔██╗ ██║██║     ██║██╔██╗ ██║█████╗      ${Red}██████${Black}╔╝${Red}██████${Black}╔╝${Red}██${Black}║   ${Red}██${Black}║${Red}██${Black}║ ${Red}█${Black}╗ ${Red}██${Black}║${Red}███████${Black}╗${Red}█████${Black}╗  ${Red}██████${Black}╔╝    ${Yellow} |"
sleep 0.1
echo -e "     |${BGreen}    ██║   ██║██║╚██╗██║██║     ██║██║╚██╗██║██╔══╝      ${BRed}██${Black}╔══${BRed}██${Black}╗${BRed}██${Black}╔══${BRed}██${Black}╗${BRed}██${Black}║   ${Red}██${Black}║${BRed}██${Black}║${BRed}███${Black}╗${BRed}██${Black}║╚════${BRed}██${Black}║${BRed}██${Black}╔══╝  ${BRed}██${Black}╔══${BRed}██${Black}╗    ${Yellow} |"
sleep 0.1
echo -e "     |${BGreen}    ╚██████╔╝██║ ╚████║███████╗██║██║ ╚████║███████╗    ${BRed}██████${Black}╔╝${BRed}██${Black}║${BRed}  ██${Black}║╚${BRed}██████${Black}╔╝╚${BRed}███${Black}╔${BRed}███${Black}╔╝${BRed}███████${Black}║${BRed}███████${Black}╗${BRed}██${Black}║  ${BRed}██${Black}║    ${Yellow} |"
sleep 0.1
echo -e "     |${Green}     ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝    ${Black}╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ${Yellow}    |"
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


echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Browser Name                       ${White}   |"
echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo -e "${White}     | ${Red}[${Yellow}01${Red}]${White} |$Green Install Chromium${White}                                           |"
echo -e "${White}     | ${Red}[${Yellow}02${Red}]${White} |$Green Install Firefox${White}                                            |"
echo -e "${White}     | ${Red}[${Yellow}03${Red}]${White} |$Green Install Opera${White}                                              |"
echo -e "${White}     | ${Red}[${Yellow}04${Red}]${White} |$Green Install Mullvad Browser${White}                                    |"
echo -e "${White}     | ${Red}[${Yellow}05${Red}]${White} |$Green Install Vivaldi${White}                                              |"
echo -e "${White}     | ${Red}[${Yellow}06${Red}]${White} |$Green Install Brave${White}                                                |"
echo -e "${White}     | ${Red}[${Yellow}07${Red}]${White} |$Green Install Edge${White}                                                 |"
echo -e "${White}     | ${Red}[${Yellow}08${Red}]${White} |$Green Install qutebrowser${White}                                        |"
echo -e "${White}     | ${Red}[${Yellow}09${Red}]${White} |$Green Install KasmVNC${White}                                              |"
echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo ""
echo -e -n "$White    ${Red} [${Cyan}!Note:${Red}]$White If your choice is Chromium type $Green 1${White} not ${Red}01$White and the same principle applies to other browsers "
echo ""
echo ""
echo -e -n "$White    ${Red} [${Cyan}!${Red}]$White Type the$BRed ID$White "
read -p "of your choice : " choice
case $choice in
    1)
        # متصفح كروم الشهير مفتوح المصدر
        echo "Installing Chromium..."
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
        # متصفح فايرفوكس المعروف، يركز على الخصوصية وحرية المستخدم
        echo "Installing Firefox..."
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
        # متصفح أوبرا، يتميز بميزاته المدمجة مثل VPN مجاني ومانع للإعلانات
        echo "Installing Opera..."
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
        # متصفح Mullvad، يركز بشكل كبير على الخصوصية والأمان، ويعمل مع خدمة Mullvad VPN
        echo "Installing Mullvad Browser..."
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
        # متصفح Vivaldi، يتيح تخصيصًا كبيرًا ويقدم ميزات قوية للمستخدمين المتقدمين
        echo "Installing Vivaldi..."
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
    6)
        # متصفح Brave، يركز على الخصوصية ومانع الإعلانات المدمج، ويستخدم نظامًا للمكافآت
        echo "Installing Brave..."
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
    7)
        # متصفح Microsoft Edge، مبني على Chromium ويقدم تجربة تصفح سريعة وموثوقة
        echo "Installing Microsoft Edge..."
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
        # متصفح qutebrowser، متصفح موجه للمستخدمين المتقدمين ويتم التحكم فيه بشكل كامل عن طريق لوحة المفاتيح
        echo "Installing qutebrowser..."
        docker run -d \
            --name=qutebrowser \
            --security-opt seccomp=unconfined \
            -e PUID=1000 \
            -e PGID=1000 \
            -e TZ=Etc/UTC \
            -p 3000:3000 \
            -p 3001:3001 \
            -v /qutebrowser:/config \
            --shm-size="7gb" \
            --restart unless-stopped \
            ghcr.io/linuxserver/qutebrowser:latest
        ;;
    9)
        # KasmVNC، يوفر سطح مكتب كامل (جهاز تحكم عن بعد) يمكنك من خلاله الوصول إلى المتصفحات والقيام بمهام أخرى
        echo "Installing KasmVNC..."
        docker run -d \
            --name=kasms-vnc \
            --security-opt seccomp=unconfined \
            -e PUID=1000 \
            -e PGID=1000 \
            -e TZ=Etc/UTC \
            -p 3000:3000 \
            -p 3001:3001 \
            -v /kasm-vnc:/config \
            --shm-size="7gb" \
            --restart unless-stopped \
            ghcr.io/linuxserver/kasms-vnc:latest
        ;;
    *)
        echo "Invalid choice. Please enter a valid number."
        exit 1
        ;;
esac

#######################################################

clear
echo ""
sleep 0.1
echo -e -n "$White    ${Red} [${Green} ✔ ${Red}]$White Browser installation completed successfully ( •̀ ω •́ )✧"
sleep 0.1
echo ""
sleep 0.1
echo ""
sleep 0.1
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⢀⣠⣴⣾⣿⣿⣿⣶⣄⡀⠀"
sleep 0.1
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄"
sleep 0.1
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⢀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷"
sleep 0.1
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤${Blue}⠾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠉⠙⣿⣿⡿"
sleep 0.1
echo -e "    ${Red} ⠀⠀⠀⠀⠀⢀⣠⠶⠛⠁⠀⠀${Blue}⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣄⣠⣿⡿⠁"
sleep 0.1
echo -e "    ${Red} ⠀⠀⣀⡤⠞⠉⠀⠀⠀⠀⠀⠀${Blue}⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀"
sleep 0.1
echo -e "    ${Red} ⢀⡾⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⠙⢿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀"
sleep 0.1
echo -e "    ${Red} ⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⡀${Blue}⠙⢿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀"
sleep 0.1
echo -e "    ${Red} ⣿⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⡿⠟⢋⣤⠶⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
sleep 0.1
echo -e "    ${Red} ⠘⣧⡀⠀⢰⣿⣶⣿⠿⠛⣩⡴⠞⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
sleep 0.1
echo -e "    ${Red} ⠀⠈⠛⠦⣤⣤⣤⡤⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
sleep 0.1
echo -e "    ${White}"
sleep 0.1
echo ""
