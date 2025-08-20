#!/bin/bash

#=======================================================
#             Browser VPS Script - Version 2
#=======================================================
# Powered by linuxserver.io and optimized for Google Cloud Shell
# Author: Gemini
# Description: This script automatically detects system resources,
# installs necessary dependencies, and provides a wide range of
# browser options for an enhanced experience.
#=======================================================

# Color codes for better aesthetics
Black='\e[0;30m'
Red='\e[0;31m'
Green='\e[0;32m'
Yellow='\e[0;33m'
Blue='\e[0;34m'
Purple='\e[0;35m'
Cyan='\e[0;36m'
White='\e[0;37m'

BBlack='\e[1;30m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
BCyan='\e[1;36m'
BWhite='\e[1;37m'

# Function to clean the screen and display the welcome banner
function display_banner() {
    clear
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
    echo -e "     |${Green}     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝    ${Black}╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ${Yellow}    |"
    sleep 0.1
    echo -e "     |                                                                                                               ${BCyan} BETA${Yellow}    |"
    sleep 0.1
    echo -e "     |                                                                                                                        |"
    sleep 0.1
    echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+"
    sleep 0.1
    echo -e "                                     |${BRed} Online Browser ${BYellow}by${BGreen} Hamza Hammouch${Cyan} powerd by${BPurple} linuxserver${Yellow} |"
    sleep 0.1
    echo -e "                                     ${Cyan}+${Yellow}--------------------------------------------------------${Cyan}+"
    echo ""
}

# Function to automatically detect system resources
function get_system_resources() {
    echo -e "${Green}جاري الكشف عن موارد النظام...${White}"
    # Get number of CPU cores
    cpu_cores=$(nproc)
    echo -e "  - ${BYellow}الأنوية المتاحة:${White} $cpu_cores"

    # Get total system memory in MB and convert to GB with one decimal place
    total_mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    total_mem_gb=$(echo "scale=1; $total_mem_kb / 1024 / 1024" | bc)
    # Set shared memory size to 80% of total memory to ensure stability
    shm_size_gb=$(echo "scale=1; $total_mem_gb * 0.8 / 1" | bc)
    if (( $(echo "$shm_size_gb < 7" | bc -l) )); then
        shm_size_gb=7 # Set a minimum of 7GB
    fi
    echo -e "  - ${BYellow}الذاكرة المتاحة:${White} ${total_mem_gb}GB"
    echo -e "  - ${BYellow}ذاكرة SHM المخصصة:${White} ${shm_size_gb}GB"

    # We will use these variables in the Docker command
    export DOCKER_CPU_CORES=$cpu_cores
    export DOCKER_SHM_SIZE="${shm_size_gb}gb"
}

# Function to check for and install dependencies
function check_dependencies() {
    if ! command -v docker &> /dev/null
    then
        echo -e "${BRed}لم يتم العثور على Docker. جاري التثبيت...${White}"
        sudo apt-get update > /dev/null 2>&1
        sudo apt-get install -y docker.io > /dev/null 2>&1
        sudo systemctl start docker > /dev/null 2>&1
        sudo systemctl enable docker > /dev/null 2>&1
        sudo usermod -aG docker $USER > /dev/null 2>&1
        echo -e "${BGreen}تم تثبيت Docker بنجاح.${White}"
    fi
    echo -e "${BGreen}تم التحقق من جميع التبعيات. جاهز للعمل.${White}"
}

# Function to list available browsers from linuxserver.io and their image names
function list_browsers() {
    # This list can be expanded by checking https://hub.docker.com/u/linuxserver
    declare -A browsers
    browsers=(
        ["1"]="chromium"
        ["2"]="firefox"
        ["3"]="firefox-dev"
        ["4"]="firefox-nightly"
        ["5"]="firefox-syncserver"
        ["6"]="mullvad-browser"
        ["7"]="opera"
        ["8"]="tor"
        ["9"]="brave"
    )

    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Browser Name                       ${White}   |"
    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    
    # Iterate through the map and print the list
    for id in "${!browsers[@]}"; do
        printf "     | ${Red}[%02d]${White} |${Green} Install %-40s${White}   |\n" "$id" "${browsers[$id]}"
    done

    echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
    echo ""
    echo -e -n "$White    ${Red} [${Cyan}!Note:${Red}]$White If your choice is Chromium type $Green 1${White} not ${Red}01$White and the same principle applies to other browsers "
    echo ""
    echo ""
    echo -e -n "$White    ${Red} [${Cyan}!${Red}]$White Type the$BRed ID$White "
    read -p "of your choice : " choice
    
    # Return the selected browser image name
    echo "${browsers[$choice]}"
}

# Main script execution
trap RM_HT_FOLDER SIGINT SIGQUIT SIGTSTP

display_banner

check_dependencies

get_system_resources

browser_image_name=$(list_browsers)

if [[ -z "$browser_image_name" ]]; then
    echo -e "${BRed}اختيار غير صالح. يرجى إدخال رقم من القائمة.${White}"
    exit 1
fi

echo ""
echo -e "${BBlue}جاري إعداد المتصفح $browser_image_name...${White}"

# Docker run command with dynamic resource allocation and improved settings
docker run -d \
    --name="$browser_image_name" \
    --security-opt seccomp=unconfined \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Etc/UTC \
    -e VIRTUAL_DISPLAY=1920x1080 \
    -e CUSTOM_PORTS=3000,3001 \
    -p 3000:3000 \
    -p 3001:3001 \
    -v "/${browser_image_name}:/config" \
    --cpus="$DOCKER_CPU_CORES" \
    --memory="$DOCKER_SHM_SIZE" \
    --shm-size="$DOCKER_SHM_SIZE" \
    --restart unless-stopped \
    ghcr.io/linuxserver/"$browser_image_name":latest

echo -e "${BGreen}تم تشغيل المتصفح بنجاح! يمكنك الآن الوصول إليه عبر المنفذ 3000.${White}"
echo ""
sleep 0.1
echo -e -n "$White    ${Red} [${Green} ✔ ${Red}]$White Browser installation completed successfully ( •̀ ω •́ )✧"
sleep 0.1
echo ""
sleep 0.1
echo ""
echo ""
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⢀⣠⣴⣾⣿⣿⣿⣶⣄⡀⠀"
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄"
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⢀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷"
echo -e "    ${Red} ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤${Blue}⠾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠉⠙⣿⣿⡿"
echo -e "    ${Red} ⠀⠀⠀⠀⠀⢀⣠⠶⠛⠁⠀⠀${Blue}⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣄⣠⣿⡿⠁"
echo -e "    ${Red} ⠀⠀⣀⡤⠞⠉⠀⠀⠀⠀⠀⠀${Blue}⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀"
echo -e "    ${Red} ⢀⡾⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${Blue}⠙⢿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀"
echo -e "    ${Red} ⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⡀${Blue}⠙⢿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo -e "    ${Red} ⣿⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⡿⠟⢋⣤⠶⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo -e "    ${Red} ⠘⣧⡀⠀⢰⣿⣶⣿⠿⠛⣩⡴⠞⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo -e "    ${Red} ⠀⠈⠛⠦⣤⣤⣤⡤⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo -e "    ${White}"
echo ""
