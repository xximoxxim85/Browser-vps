#!/bin/bash

# إعدادات الألوان المحسنة
NC='\e[0m'          # No Color
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
PURPLE='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
BOLD_BLACK='\e[1;30m'
BOLD_RED='\e[1;31m'
BOLD_GREEN='\e[1;32m'
BOLD_YELLOW='\e[1;33m'
BOLD_BLUE='\e[1;34m'
BOLD_PURPLE='\e[1;35m'
BOLD_CYAN='\e[1;36m'
BOLD_WHITE='\e[1;37m'

# دالة للتحقق من الأخطاء
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${BOLD_RED}[ERROR]${NC} $1"
        exit 1
    fi
}

# دالة لجلب معلومات النظام
get_system_info() {
    echo -e "${BOLD_CYAN}جمع معلومات النظام...${NC}"
    TOTAL_RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    AVAILABLE_RAM=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    CPU_CORES=$(nproc)
    SWAP_SIZE=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
    DISK_SPACE=$(df / | tail -1 | awk '{print $4}')
    
    echo -e "${BOLD_GREEN}موارد النظام:${NC}"
    echo -e " - الذاكرة RAM: $((TOTAL_RAM / 1024)) MB (متاح: $((AVAILABLE_RAM / 1024)) MB)"
    echo -e " - نوى المعالج: $CPU_CORES"
    echo -e " - مساحة التبديل: $((SWAP_SIZE / 1024)) MB"
    echo -e " - مساحة القرص: $((DISK_SPACE / 1024)) MB"
    
    # حساب حجم الذاكرة المشتركة المثالي بناءً على الذاكرة المتاحة
    if [ $AVAILABLE_RAM -gt 8000000 ]; then
        SHM_SIZE="8gb"
    elif [ $AVAILABLE_RAM -gt 4000000 ]; then
        SHM_SIZE="4gb"
    elif [ $AVAILABLE_RAM -gt 2000000 ]; then
        SHM_SIZE="2gb"
    else
        SHM_SIZE="1gb"
    fi
    
    # تحديد عدد مراكز المعالجة المثالي
    if [ $CPU_CORES -gt 8 ]; then
        CPU_COUNT=8
    elif [ $CPU_CORES -gt 4 ]; then
        CPU_COUNT=4
    else
        CPU_COUNT=2
    fi
}

# دالة لتحسين إعدادات النظام
optimize_system() {
    echo -e "${BOLD_CYAN}تحسين إعدادات النظام...${NC}"
    
    # زيادة حجم الذاكرة المشتركة
    mount -o remount,size=${SHM_SIZE} /dev/shm
    check_error "فشل في تعديل حجم الذاكرة المشتركة"
    
    # تحسين إعدادات الشبكة
    sysctl -w net.core.rmem_max=26214400
    sysctl -w net.core.wmem_max=26214400
    sysctl -w net.ipv4.tcp_rmem='4096 87380 26214400'
    sysctl -w net.ipv4.tcp_wmem='4096 65536 26214400'
    
    # تحسين إعدادات نظام الملفات
    sysctl -w vm.swappiness=10
    sysctl -w vm.vfs_cache_pressure=50
    
    echo -e "${BOLD_GREEN}تم تحسين إعدادات النظام بنجاح${NC}"
}

# دالة للتحقق من تثبيت Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${BOLD_RED}Docker غير مثبت${NC}"
        echo -e "${BOLD_YELLOW}جاري تثبيت Docker...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        check_error "فشل في تثبيت Docker"
        rm get-docker.sh
    fi
    
    # تشغيل خدمة Docker إذا لم تكن تعمل
    if ! systemctl is-active --quiet docker; then
        echo -e "${BOLD_YELLOW}تشغيل خدمة Docker...${NC}"
        systemctl start docker
        systemctl enable docker
        check_error "فشل في تشغيل Docker"
    fi
    
    echo -e "${BOLD_GREEN}Docker جاهز للاستخدام${NC}"
}

# دالة لإنشاء شبكة Docker معزولة
create_network() {
    if ! docker network ls | grep -q "browser_network"; then
        echo -e "${BOLD_CYAN}إنشاء شبكة معزولة للمتصفحات...${NC}"
        docker network create browser_network
        check_error "فشل في إنشاء الشبكة"
    fi
}

# دالة لتحميل وتشغيل المتصفح
run_browser() {
    local name=$1
    local image=$2
    local port=$3
    
    echo -e "${BOLD_CYAN}جاري تثبيت ${name}...${NC}"
    
    # إيقاف وإزالة الحاوية القديمة إذا كانت موجودة
    if docker ps -a | grep -q "${name}"; then
        echo -e "${BOLD_YELLOW}إزالة الإصدار القديم من ${name}...${NC}"
        docker stop "${name}" >/dev/null 2>&1
        docker rm "${name}" >/dev/null 2>&1
    fi
    
    # إنشاء مجلد التهيئة
    mkdir -p "/config/${name}"
    
    # تشغيل المتصفح مع الإعدادات المحسنة
    docker run -d \
        --name="${name}" \
        --network=browser_network \
        --cpus=${CPU_COUNT} \
        --memory=$((${AVAILABLE_RAM} / 1024 * 80 / 100))k \
        --memory-swap=$((${SWAP_SIZE} / 1024 * 80 / 100))k \
        --security-opt seccomp=unconfined \
        --cap-add=SYS_ADMIN \
        --device /dev/dri:/dev/dri \
        --shm-size="${SHM_SIZE}" \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ=$(cat /etc/timezone) \
        -e NVIDIA_DRIVER_CAPABILITIES=all \
        -e NVIDIA_VISIBLE_DEVICES=all \
        -p ${port}:3000 \
        -p $((${port} + 1)):3001 \
        -v "/config/${name}":/config \
        -v /tmp:/tmp \
        --restart unless-stopped \
        "${image}"
    
    check_error "فشل في تشغيل ${name}"
    
    echo -e "${BOLD_GREEN}تم تثبيت ${name} بنجاح على المنفذ ${port}${NC}"
}

# دالة للعرض البصري المحسن
show_banner() {
    clear
    echo -e "${BOLD_CYAN}"
    cat << "EOF"
    ┌──────────────────────────────────────────────────────────────────────────────┐
    │                                                                              │
    │    ██████╗ ██████╗  ██████╗ ██╗    ██╗███████╗███████╗██████╗ ███████╗       │
    │    ██╔══██╗██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔════╝██╔══██╗██╔════╝       │
    │    ██████╔╝██████╔╝██║   ██║██║ █╗ ██║███████╗█████╗  ██████╔╝███████╗       │
    │    ██╔══██╗██╔══██╗██║   ██║██║███╗██║╚════██║██╔══╝  ██╔══██╗╚════██║       │
    │    ██████╔╝██║  ██║╚██████╔╝╚███╔███╔╝███████║███████╗██║  ██║███████║       │
    │    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝       │
    │                                                                              │
    │                         Browser VPS Manager - Enhanced                       │
    │                                                                              │
    └──────────────────────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
}

# دالة لعرض القائمة الرئيسية
show_menu() {
    echo -e "${BOLD_YELLOW}"
    echo "    +-------------------------------------------------------------------+"
    echo "    | ${BOLD_WHITE}ID ${BOLD_YELLOW} |                   ${BOLD_PURPLE}Browser Name${BOLD_YELLOW}                       |"
    echo "    +-------------------------------------------------------------------+"
    echo "    | ${GREEN}[1]${BOLD_YELLOW}  |${GREEN} Install Chromium${BOLD_YELLOW}                                   |"
    echo "    | ${GREEN}[2]${BOLD_YELLOW}  |${GREEN} Install Firefox${BOLD_YELLOW}                                    |"
    echo "    | ${GREEN}[3]${BOLD_YELLOW}  |${GREEN} Install Opera${BOLD_YELLOW}                                      |"
    echo "    | ${GREEN}[4]${BOLD_YELLOW}  |${GREEN} Install Mullvad Browser${BOLD_YELLOW}                            |"
    echo "    | ${GREEN}[5]${BOLD_YELLOW}  |${GREEN} Install Brave${BOLD_YELLOW}                                      |"
    echo "    | ${GREEN}[6]${BOLD_YELLOW}  |${GREEN} Install Vivaldi${BOLD_YELLOW}                                    |"
    echo "    | ${GREEN}[7]${BOLD_YELLOW}  |${GREEN} Install Tor Browser${BOLD_YELLOW}                                |"
    echo "    | ${GREEN}[8]${BOLD_YELLOW}  |${GREEN} Install Edge${BOLD_YELLOW}                                       |"
    echo "    | ${GREEN}[9]${BOLD_YELLOW}  |${GREEN} Install Lynx (Text-based)${BOLD_YELLOW}                          |"
    echo "    | ${GREEN}[10]${BOLD_YELLOW} |${GREEN} Install All Browsers${BOLD_YELLOW}                               |"
    echo "    | ${RED}[0]${BOLD_YELLOW}  |${RED} Exit${BOLD_YELLOW}                                                  |"
    echo "    +-------------------------------------------------------------------+"
    echo -e "${NC}"
}

# دالة للخيار المتقدم للإعدادات
advanced_settings() {
    echo -e "${BOLD_CYAN}"
    echo "الإعدادات المتقدمة:"
    echo -e "${BOLD_WHITE}[1]${NC} تغيير منفذ التشغيل الافتراضي (الحالي: ${BOLD_GREEN}${START_PORT}${NC})"
    echo -e "${BOLD_WHITE}[2]${NC} تغيير حجم الذاكرة المشتركة (الحالي: ${BOLD_GREEN}${SHM_SIZE}${NC})"
    echo -e "${BOLD_WHITE}[3]${NC} عرض حالة الحاويات"
    echo -e "${BOLD_WHITE}[4]${NC} إزالة جميع المتصفحات"
    echo -e "${BOLD_WHITE}[5]${NC} العودة إلى القائمة الرئيسية"
    
    read -p "اختر خيارًا: " advanced_choice
    case $advanced_choice in
        1)
            read -p "أدخل منفذ البدء الجديد: " new_port
            if [[ $new_port =~ ^[0-9]+$ ]] && [ $new_port -ge 1024 ] && [ $new_port -le 65535 ]; then
                START_PORT=$new_port
                echo -e "${BOLD_GREEN}تم تغيير منفذ البدء إلى ${START_PORT}${NC}"
            else
                echo -e "${BOLD_RED}منفذ غير صالح${NC}"
            fi
            ;;
        2)
            read -p "أدخل حجم الذاكرة المشتركة الجديد (مثال: 2gb, 512mb): " new_shm
            if [[ $new_shm =~ ^[0-9]+(gb|mb)$ ]]; then
                SHM_SIZE=$new_shm
                echo -e "${BOLD_GREEN}تم تغيير حجم الذاكرة المشتركة إلى ${SHM_SIZE}${NC}"
            else
                echo -e "${BOLD_RED}حجم غير صالح${NC}"
            fi
            ;;
        3)
            echo -e "${BOLD_CYAN}حالة الحاويات الحالية:${NC}"
            docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
            ;;
        4)
            echo -e "${BOLD_RED}إزالة جميع متصفحات Docker...${NC}"
            docker stop $(docker ps -a -q) >/dev/null 2>&1
            docker rm $(docker ps -a -q) >/dev/null 2>&1
            echo -e "${BOLD_GREEN}تم إزالة جميع الحاويات${NC}"
            ;;
        5)
            return
            ;;
        *)
            echo -e "${BOLD_RED}خيار غير صالح${NC}"
            ;;
    esac
    read -n 1 -s -r -p "اضغط أي مفتاح للمتابعة..."
}

# دالة للخروج النظيف
cleanup() {
    echo -e "${BOLD_CYAN}تنظيف الموارد...${NC}"
    # إعادة تعيين إعدادات النظام
    sysctl -w net.core.rmem_max=212992
    sysctl -w net.core.wmem_max=212992
    sysctl -w net.ipv4.tcp_rmem='4096 87380 6291456'
    sysctl -w net.ipv4.tcp_wmem='4096 16384 4194304'
    echo -e "${BOLD_GREEN}تم التنظيف بنجاح${NC}"
    exit 0
}

# الإعدادات الرئيسية
trap cleanup SIGINT SIGQUIT SIGTSTP
START_PORT=3000

# البداية الرئيسية للبرنامج
main() {
    show_banner
    check_docker
    get_system_info
    optimize_system
    create_network
    
    while true; do
        show_banner
        show_menu
        
        echo -e -n "${BOLD_WHITE}    [${CYAN}!${WHITE}] أدخل رقم المتصفح الذي تريد تثبيته (0 للخروج، A للإعدادات المتقدمة): ${NC}"
        read choice
        
        case $choice in
            1)
                run_browser "chromium" "ghcr.io/linuxserver/chromium:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            2)
                run_browser "firefox" "ghcr.io/linuxserver/firefox:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            3)
                run_browser "opera" "ghcr.io/linuxserver/opera:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            4)
                run_browser "mullvad-browser" "ghcr.io/linuxserver/mullvad-browser:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            5)
                run_browser "brave" "ghcr.io/linuxserver/brave:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            6)
                run_browser "vivaldi" "ghcr.io/linuxserver/vivaldi:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            7)
                run_browser "tor-browser" "ghcr.io/linuxserver/tor-browser:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            8)
                run_browser "edge" "ghcr.io/linuxserver/edge:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            9)
                run_browser "lynx" "ghcr.io/linuxserver/lynx:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                ;;
            10)
                echo -e "${BOLD_CYAN}جاري تثبيت جميع المتصفحات...${NC}"
                run_browser "chromium" "ghcr.io/linuxserver/chromium:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                run_browser "firefox" "ghcr.io/linuxserver/firefox:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                run_browser "opera" "ghcr.io/linuxserver/opera:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                run_browser "mullvad-browser" "ghcr.io/linuxserver/mullvad-browser:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                run_browser "brave" "ghcr.io/linuxserver/brave:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                run_browser "vivaldi" "ghcr.io/linuxserver/vivaldi:latest" $START_PORT
                START_PORT=$((START_PORT + 10))
                echo -e "${BOLD_GREEN}تم تثبيت جميع المتصفحات بنجاح${NC}"
                ;;
            a|A)
                advanced_settings
                continue
                ;;
            0)
                cleanup
                ;;
            *)
                echo -e "${BOLD_RED}خيار غير صالح!${NC}"
                sleep 1
                continue
                ;;
        esac
        
        echo -e "${BOLD_GREEN}تم الانتهاء من التثبيت بنجاح!${NC}"
        echo -e "${BOLD_WHITE}يمكنك الوصول إلى المتصفح عبر: ${BOLD_CYAN}http://your-server-ip:${START_PORT}${NC}"
        read -n 1 -s -r -p "اضغط أي مفتاح للمتابعة..."
    done
}

# بدء البرنامج الرئيسي
main
