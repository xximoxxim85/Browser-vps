#!/bin/bash

# Regular Colors
Black='\033[0;30m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
White='\033[0;37m'

# Bold
BBlack='\033[1;30m'
BRed='\033[1;31m'
BGreen='\033[1;32m'
BYellow='\033[1;33m'
BBlue='\033[1;34m'
BPurple='\033[1;35m'
BCyan='\033[1;36m'
BWhite='\033[1;37m'

# Reset
NC='\033[0m'

#######################################################
# دالة لجمع المعلومات عن النظام
get_system_info() {
    echo -e "${Yellow}جمع معلومات النظام...${NC}"
    TOTAL_MEMORY=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    TOTAL_MEMORY_GB=$((TOTAL_MEMORY / 1024 / 1024))
    AVAILABLE_MEMORY=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    AVAILABLE_MEMORY_GB=$((AVAILABLE_MEMORY / 1024 / 1024))
    CPU_CORES=$(nproc)
    SWAP_SIZE=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
    SWAP_SIZE_GB=$((SWAP_SIZE / 1024 / 1024))
    
    # حساب حجم الذاكرة المشتركة المثالي (نصف الذاكرة المتاحة بحد أقصى 8GB)
    CALCULATED_SHM=$((AVAILABLE_MEMORY / 2 / 1024 / 1024))
    if [ $CALCULATED_SHM -gt 8 ]; then
        SHM_SIZE="8gb"
    elif [ $CALCULATED_SHM -lt 1 ]; then
        SHM_SIZE="1gb"
    else
        SHM_SIZE="${CALCULATED_SHM}gb"
    fi
}

# دالة لتحسين إعدادات النظام
optimize_system() {
    echo -e "${Yellow}تحسين إعدادات النظام...${NC}"
    
    # زيادة مساحة الذاكرة المشتركة إذا كانت منخفضة
    if [ $CALCULATED_SHM -lt 2 ]; then
        mount -o remount,size=2G /dev/shm
    fi
    
    # تحسين إعدادات الشبكة
    sysctl -w net.core.rmem_max=26214400
    sysctl -w net.core.wmem_max=26214400
    sysctl -w net.core.rmem_default=26214400
    sysctl -w net.core.wmem_default=26214400
    sysctl -w net.core.optmem_max=26214400
    sysctl -w net.ipv4.tcp_rmem='4096 87380 26214400'
    sysctl -w net.ipv4.tcp_wmem='4096 65536 26214400'
}

# دالة لإنشاء الحاوية
create_container() {
    local name=$1
    local image=$2
    local extra_args=$3
    
    echo -e "${Green}جاري تثبيت ${name}...${NC}"
    
    # إيقاف الحاوية إذا كانت تعمل
    docker stop $name 2>/dev/null || true
    docker rm $name 2>/dev/null || true
    
    # إنشاء الحاوية مع الإعدادات المحسنة
    docker run -d \
        --name=${name} \
        --security-opt seccomp=unconfined \
        --device /dev/dri:/dev/dri \
        --shm-size=${SHM_SIZE} \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ=Etc/UTC \
        -e NVIDIA_DRIVER_CAPABILITIES=all \
        -e NVIDIA_VISIBLE_DEVICES=all \
        -p 3000:3000 \
        -p 3001:3001 \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v ${name}_config:/config \
        --cpus=${CPU_CORES} \
        --memory=${AVAILABLE_MEMORY_GB}G \
        --restart unless-stopped \
        ${extra_args} \
        ${image}
    
    echo -e "${BGreen}تم تثبيت ${name} بنجاح!${NC}"
}

#######################################################

clear
echo -e "${NC}"

get_system_info
optimize_system

echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+"
echo -e "${Yellow}     |                                                                                                                        |"
echo -e "     |${Green}     ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó ‚Ėą‚Ėą‚Ėą‚ēó   ‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēó     ‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚Ėą‚ēó   ‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó    ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red} ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}  ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red} ‚Ėą‚Ėą${Black}‚ēó${Red}    ‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó  ${Yellow}    |"
echo -e "     |${Green}    ‚Ėą‚Ėą‚ēĒ‚ēź‚ēź‚ēź‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚Ėą‚Ėą‚ēó  ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ     ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚ēó  ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚ēź‚ēź‚ēź‚ēź‚ēĚ    ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą${Black}‚ēĎ${Red}    ‚Ėą‚Ėą${Black}‚ēĎ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēź‚ēź‚ēĚ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēź‚ēź‚ēĚ${Red}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${Red}‚Ėą‚Ėą${Black}‚ēó${Red}    ${Yellow} |"
echo -e "     |${Green}    ‚Ėą‚Ėą‚ēĎ   ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚Ėą‚Ėą‚ēó ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ     ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚Ėą‚Ėą‚ēó ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó      ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${Red}‚Ėą‚Ėą${Black}‚ēĎ   ${Red}‚Ėą‚Ėą${Black}‚ēĎ${Red}‚Ėą‚Ėą${Black}‚ēĎ ${Red}‚Ėą${Black}‚ēó ${Red}‚Ėą‚Ėą${Black}‚ēĎ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó  ${Red}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ    ${Yellow} |"
echo -e "     |${BGreen}    ‚Ėą‚Ėą‚ēĎ   ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ‚ēö‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ     ‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ‚ēö‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĒ‚ēź‚ēź‚ēĚ      ${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĎ   ${Red}‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĎ‚ēö‚ēź‚ēź‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź‚ēĚ  ${BRed}‚Ėą‚Ėą${Black}‚ēĒ‚ēź‚ēź${BRed}‚Ėą‚Ėą${Black}‚ēó    ${Yellow} |"
echo -e "     |${BGreen}    ‚ēö‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēĒ‚ēĚ‚Ėą‚Ėą‚ēĎ ‚ēö‚Ėą‚Ėą‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚ēĎ ‚ēö‚Ėą‚Ėą‚Ėą‚Ėą‚ēĎ‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚ēó    ${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${BRed}‚Ėą‚Ėą${Black}‚ēĎ${BRed}  ‚Ėą‚Ėą${Black}‚ēĎ‚ēö${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ‚ēö${BRed}‚Ėą‚Ėą‚Ėą${Black}‚ēĒ${BRed}‚Ėą‚Ėą‚Ėą${Black}‚ēĒ‚ēĚ${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēĎ${BRed}‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą‚Ėą${Black}‚ēó${BRed}‚Ėą‚Ėą${Black}‚ēĎ  ${BRed}‚Ėą‚Ėą${Black}‚ēĎ    ${Yellow} |"
echo -e "     |${Green}     ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēĚ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ    ${Black}‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēĚ ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ  ‚ēö‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēĚ ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēź‚ēź‚ēź‚ēź‚ēź‚ēĚ‚ēö‚ēź‚ēĚ  ‚ēö‚ēź‚ēĚ ${Yellow}    |"
echo -e "     |                                                                                                               ${BCyan} BETA${Yellow}    |"
echo -e "     |                                                                                                                        |"
echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+${Yellow}"
echo -e "                                     |${BRed} Online Browser ${BYellow}by${BGreen} Hamza Hammouch${Cyan} powerd by${BPurple} linuxserver${Yellow} |"
echo -e "                                     ${Cyan}+${Yellow}--------------------------------------------------------${Cyan}+"

echo -e "${Yellow}معلومات النظام:${NC}"
echo -e "${White}الذاكرة الكاملة: ${TOTAL_MEMORY_GB}GB${NC}"
echo -e "${White}الذاكرة المتاحة: ${AVAILABLE_MEMORY_GB}GB${NC}"
echo -e "${White}عدد نوى المعالج: ${CPU_CORES}${NC}"
echo -e "${White}حجم الذاكرة المشتركة: ${SHM_SIZE}${NC}"

echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Browser Name                       ${White}   |"
echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo -e "${White}     | ${Red}[${Yellow}01${Red}]${White} |$Green Install Chromium${White}                                           |"
echo -e "${White}     | ${Red}[${Yellow}02${Red}]${White} |$Green Install Firefox${White}                                            |"
echo -e "${White}     | ${Red}[${Yellow}03${Red}]${White} |$Green Install Opera${White}                                              |"
echo -e "${White}     | ${Red}[${Yellow}04${Red}]${White} |$Green Install Mullvad Browser${White}                                    |"
echo -e "${White}     | ${Red}[${Yellow}05${Red}]${White} |$Green Install Brave${White}                                              |"
echo -e "${White}     | ${Red}[${Yellow}06${Red}]${White} |$Green Install Vivaldi${White}                                            |"
echo -e "${White}     | ${Red}[${Yellow}07${Red}]${White} |$Green Install Microsoft Edge${White}                                     |"
echo -e "${White}     | ${Red}[${Yellow}08${Red}]${White} |$Green Install Tor Browser${White}                                        |"
echo -e "${White}     | ${Red}[${Yellow}09${Red}]${White} |$Green Install Falkon${White}                                             |"
echo -e "${White}     | ${Red}[${Yellow}10${Red}]${White} |$Green Install Nyxt${White}                                               |"
echo -e "${White}     | ${Red}[${Yellow}11${Red}]${White} |$Green Install Lynx (Text Browser)${White}                                |"
echo -e "${White}     | ${Red}[${Yellow}12${Red}]${White} |$Green Install All Browsers${White}                                       |"
echo -e "${White}     | ${Red}[${Yellow}13${Red}]${White} |$Green Manage Containers${White}                                          |"
echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
echo ""
echo -e -n "$White    ${Red} [${Cyan}!Note:${Red}]$White If your choice is Chromium type $Green 1${White} not ${Red}01$White and the same principle applies to other browsers "
echo ""
echo ""
echo -e -n "$White    ${Red} [${Cyan}!${Red}]$White Type the$BRed ID$White "
read -p "of your choice : " choice

case $choice in
    1)
        create_container "chromium" "ghcr.io/linuxserver/chromium:latest" "--cap-add=SYS_ADMIN"
        ;;
    2)
        create_container "firefox" "ghcr.io/linuxserver/firefox:latest" ""
        ;;
    3)
        create_container "opera" "ghcr.io/linuxserver/opera:latest" ""
        ;;
    4)
        create_container "mullvad-browser" "ghcr.io/linuxserver/mullvad-browser:latest" ""
        ;;
    5)
        create_container "brave" "ghcr.io/linuxserver/brave:latest" "--cap-add=SYS_ADMIN"
        ;;
    6)
        create_container "vivaldi" "ghcr.io/linuxserver/vivaldi:latest" ""
        ;;
    7)
        create_container "edge" "ghcr.io/linuxserver/edge:latest" ""
        ;;
    8)
        create_container "tor-browser" "ghcr.io/linuxserver/tor-browser:latest" ""
        ;;
    9)
        create_container "falkon" "ghcr.io/linuxserver/falkon:latest" ""
        ;;
    10)
        create_container "nyxt" "ghcr.io/linuxserver/nyxt:latest" ""
        ;;
    11)
        create_container "lynx" "ghcr.io/linuxserver/lynx:latest" ""
        ;;
    12)
        echo -e "${Yellow}جاري تثبيت جميع المتصفحات...${NC}"
        create_container "chromium" "ghcr.io/linuxserver/chromium:latest" "--cap-add=SYS_ADMIN"
        create_container "firefox" "ghcr.io/linuxserver/firefox:latest" ""
        create_container "opera" "ghcr.io/linuxserver/opera:latest" ""
        create_container "mullvad-browser" "ghcr.io/linuxserver/mullvad-browser:latest" ""
        create_container "brave" "ghcr.io/linuxserver/brave:latest" "--cap-add=SYS_ADMIN"
        create_container "vivaldi" "ghcr.io/linuxserver/vivaldi:latest" ""
        ;;
    13)
        echo -e "${Yellow}إدارة الحاويات:${NC}"
        echo -e "${White}1. عرض الحاويات النشطة${NC}"
        echo -e "${White}2. إعادة تشغيل حاوية${NC}"
        echo -e "${White}3. إيقاف حاوية${NC}"
        echo -e "${White}4. حذف حاوية${NC}"
        read -p "اختر الخيار: " manage_choice
        
        case $manage_choice in
            1)
                docker ps
                ;;
            2)
                read -p "أدخل اسم الحاوية: " container_name
                docker restart $container_name
                ;;
            3)
                read -p "أدخل اسم الحاوية: " container_name
                docker stop $container_name
                ;;
            4)
                read -p "أدخل اسم الحاوية: " container_name
                docker stop $container_name
                docker rm $container_name
                ;;
            *)
                echo -e "${Red}خيار غير صحيح!${NC}"
                ;;
        esac
        ;;
    *)
        echo -e "${Red}Invalid choice. Please enter a valid option.${NC}"
        exit 1
        ;;
esac

#######################################################

clear
echo ""
echo -e -n "$White    ${Red} [${Green} ‚úĒ ${Red}]$White Browser installation completed successfully ( ‚ÄĘŐÄ ŌČ ‚ÄĘŐĀ )‚úß"
echo ""
echo ""
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚ĘÄ‚£†‚£ī‚£ĺ‚£Ņ‚£Ņ‚£Ņ‚£∂‚£Ą‚°Ä‚†Ä"
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚£Ä‚£§‚£ĺ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£∑‚°Ą"
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚ĘÄ‚£†‚£ī‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£∑"
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚£Ä‚°§${Blue}‚†ĺ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚°ü‚†Č‚†ô‚£Ņ‚£Ņ‚°Ņ"
echo -e "    ${Red} ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚ĘÄ‚£†‚†∂‚†õ‚†Ā‚†Ä‚†Ä${Blue}‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£ß‚£Ą‚£†‚£Ņ‚°Ņ‚†Ā"
echo -e "    ${Red} ‚†Ä‚†Ä‚£Ä‚°§‚†ě‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚†ł‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚°Ņ‚†ü‚†č‚†Ä‚†Ä"
echo -e "    ${Red} ‚ĘÄ‚°ĺ‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä${Blue}‚†ô‚ĘŅ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚£Ņ‚†Ņ‚†õ‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
echo -e "    ${Red} ‚£ĺ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚ĘÄ‚£†‚£§‚°Ä${Blue}‚†ô‚ĘŅ‚£Ņ‚°Ņ‚†ü‚†č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
echo -e "    ${Red} ‚£Ņ‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚£†‚£ī‚£ĺ‚°Ņ‚†ü‚Ęč‚£§‚†∂‚†õ‚†Ā‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
echo -e "    ${Red} ‚†ė‚£ß‚°Ä‚†Ä‚Ęį‚£Ņ‚£∂‚£Ņ‚†Ņ‚†õ‚£©‚°ī‚†ě‚†Č‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
echo -e "    ${Red} ‚†Ä‚†ą‚†õ‚†¶‚£§‚£§‚£§‚°§‚†Ė‚†č‚†Ā‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä‚†Ä"
echo -e "    ${White}"

# عرض معلومات الاتصال
echo -e "${BGreen}معلومات الاتصال:${NC}"
echo -e "${White}للاتصال بالمتصفح، افتح المتصفح على جهازك واذهب إلى:${NC}"
echo -e "${Yellow}https://shell.cloud.google.com/devshell/proxy?authuser=0&port=3000${NC}"
echo ""
echo -e "${BYellow}نصائح لتحسين الأداء:${NC}"
echo -e "${White}- تأكد من وجود اتصال إنترنت سريع ومستقر${NC}"
echo -e "${White}- أغبق التطبيقات غير الضرورية لتحرير الذاكرة${NC}"
echo -e "${White}- استخدم دقة شاشة مناسبة (ليست最高 دقة)${NC}"
echo -e "${White}- قم بتحديث الصفحة إذا واجهت أي مشاكل في الاتصال${NC}"
