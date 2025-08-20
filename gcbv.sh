#!/bin/bash

# Enhanced Online Browser Installer with Auto-Detection
# Developed based on LinuxServer.io images

# Clear screen and set trap
clear
trap 'echo -e "\n${RED}Script interrupted. Cleaning up...${NC}"; exit 1' SIGINT SIGQUIT SIGTSTP

# Configuration
CONFIG_DIR="$HOME/browser-config"
LOG_FILE="$CONFIG_DIR/installation.log"
TEMP_DIR="/tmp/browser-installer"
BENCHMARK_FILE="$TEMP_DIR/benchmark.txt"

# Enhanced Color Definitions
NC='\033[0m' # No Color
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
ITALIC='\033[3m'

# Background colors
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_BLUE='\033[44m'
BG_YELLOW='\033[43m'

# Function for formatted output
print_status() {
    echo -e "${BLUE}[${YELLOW}*${BLUE}]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[${WHITE}✓${GREEN}]${NC} $1"
}

print_error() {
    echo -e "${RED}[${WHITE}!${RED}]${NC} $1"
}

print_header() {
    echo -e "${BLUE}${BOLD}==================================================${NC}"
    echo -e "${CYAN}${BOLD}          $1${NC}"
    echo -e "${BLUE}${BOLD}==================================================${NC}"
}

# Auto-detect system resources
detect_system_resources() {
    print_status "Detecting system resources..."
    
    # CPU detection
    CPU_CORES=$(nproc)
    CPU_THREADS=$(grep -c "processor" /proc/cpuinfo)
    CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^[ \t]*//')
    
    # RAM detection
    TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    TOTAL_RAM_GB=$((TOTAL_RAM_KB / 1024 / 1024))
    AVAILABLE_RAM_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    AVAILABLE_RAM_GB=$((AVAILABLE_RAM_KB / 1024 / 1024))
    
    # GPU detection
    if command -v lspci > /dev/null; then
        GPU_INFO=$(lspci | grep -i "vga\|3d\|display" | head -1)
        if echo "$GPU_INFO" | grep -qi "nvidia"; then
            GPU_TYPE="nvidia"
        elif echo "$GPU_INFO" | grep -qi "amd"; then
            GPU_TYPE="amd"
        elif echo "$GPU_INFO" | grep -qi "intel"; then
            GPU_TYPE="intel"
        else
            GPU_TYPE="unknown"
        fi
    else
        GPU_TYPE="unknown"
    fi
    
    # Disk speed detection (simple test)
    if command -v dd > /dev/null && [ -w "/tmp" ]; then
        DISK_SPEED=$(dd if=/dev/zero of=/tmp/testfile bs=1M count=1024 2>&1 | grep copied | awk '{print $8 $9}')
        rm -f /tmp/testfile
    else
        DISK_SPEED="unknown"
    fi
    
    print_success "System resources detected"
}

# Auto-detect network speed
detect_network_speed() {
    print_status "Testing network speed..."
    
    # Try to detect network speed using various methods
    if command -v speedtest-cli > /dev/null; then
        # Use speedtest-cli if available
        speedtest-cli --simple > "$TEMP_DIR/speedtest.txt" 2>/dev/null &
        SPEEDTEST_PID=$!
        sleep 10
        if kill -0 $SPEEDTEST_PID 2>/dev/null; then
            kill $SPEEDTEST_PID 2>/dev/null
            NETWORK_SPEED="medium"
        else
            PING=$(grep -i ping "$TEMP_DIR/speedtest.txt" | awk '{print $2}')
            DOWNLOAD=$(grep -i download "$TEMP_DIR/speedtest.txt" | awk '{print $2}')
            UPLOAD=$(grep -i upload "$TEMP_DIR/speedtest.txt" | awk '{print $2}')
            
            if [ ! -z "$DOWNLOAD" ]; then
                if (( $(echo "$DOWNLOAD > 50" | bc -l) )); then
                    NETWORK_SPEED="very_high"
                    BITRATE="5000k"
                    BUFFER_SIZE="10000k"
                elif (( $(echo "$DOWNLOAD > 25" | bc -l) )); then
                    NETWORK_SPEED="high"
                    BITRATE="3000k"
                    BUFFER_SIZE="6000k"
                elif (( $(echo "$DOWNLOAD > 10" | bc -l) )); then
                    NETWORK_SPEED="medium"
                    BITRATE="1500k"
                    BUFFER_SIZE="3000k"
                elif (( $(echo "$DOWNLOAD > 5" | bc -l) )); then
                    NETWORK_SPEED="low"
                    BITRATE="800k"
                    BUFFER_SIZE="1600k"
                else
                    NETWORK_SPEED="very_low"
                    BITRATE="500k"
                    BUFFER_SIZE="1000k"
                fi
            else
                NETWORK_SPEED="unknown"
                BITRATE="1500k"
                BUFFER_SIZE="3000k"
            fi
        fi
    else
        # Fallback method - try to download a test file
        TEST_URL="http://cachefly.cachefly.net/100mb.test"
        START_TIME=$(date +%s)
        curl -o /dev/null -s -w "%{speed_download}" "$TEST_URL" > "$TEMP_DIR/curl_speed.txt" 2>/dev/null &
        CURL_PID=$!
        sleep 5
        if kill -0 $CURL_PID 2>/dev/null; then
            kill $CURL_PID 2>/dev/null
            NETWORK_SPEED="medium"
            BITRATE="1500k"
            BUFFER_SIZE="3000k"
        else
            DL_SPEED=$(cat "$TEMP_DIR/curl_speed.txt")
            DL_SPEED_MBPS=$(echo "scale=2; $DL_SPEED / 125000" | bc)
            
            if (( $(echo "$DL_SPEED_MBPS > 50" | bc -l) )); then
                NETWORK_SPEED="very_high"
                BITRATE="5000k"
                BUFFER_SIZE="10000k"
            elif (( $(echo "$DL_SPEED_MBPS > 25" | bc -l) )); then
                NETWORK_SPEED="high"
                BITRATE="3000k"
                BUFFER_SIZE="6000k"
            elif (( $(echo "$DL_SPEED_MBPS > 10" | bc -l) )); then
                NETWORK_SPEED="medium"
                BITRATE="1500k"
                BUFFER_SIZE="3000k"
            elif (( $(echo "$DL_SPEED_MBPS > 5" | bc -l) )); then
                NETWORK_SPEED="low"
                BITRATE="800k"
                BUFFER_SIZE="1600k"
            else
                NETWORK_SPEED="very_low"
                BITRATE="500k"
                BUFFER_SIZE="1000k"
            fi
        fi
    fi
    
    # If all else fails, use medium settings
    if [ -z "$NETWORK_SPEED" ]; then
        NETWORK_SPEED="medium"
        BITRATE="1500k"
        BUFFER_SIZE="3000k"
    fi
    
    print_success "Network speed detected: $NETWORK_SPEED (${DL_SPEED_MBPS}Mbps)"
}

# Calculate optimal settings based on system resources
calculate_optimal_settings() {
    print_status "Calculating optimal settings..."
    
    # Calculate CPU allocation (use 75% of available cores, min 2, max 8)
    OPTIMAL_CPUS=$((CPU_THREADS * 3 / 4))
    if [ $OPTIMAL_CPUS -lt 2 ]; then
        OPTIMAL_CPUS=2
    elif [ $OPTIMAL_CPUS -gt 8 ]; then
        OPTIMAL_CPUS=8
    fi
    
    # Calculate RAM allocation (use 70% of available RAM, min 2GB, max 16GB)
    OPTIMAL_RAM=$((AVAILABLE_RAM_KB * 70 / 100 / 1024 / 1024))
    if [ $OPTIMAL_RAM -lt 2 ]; then
        OPTIMAL_RAM=2
    elif [ $OPTIMAL_RAM -gt 16 ]; then
        OPTIMAL_RAM=16
    fi
    
    # Calculate swap allocation (1.5x RAM)
    OPTIMAL_SWAP=$((OPTIMAL_RAM * 3 / 2))
    
    # Calculate SHM size based on RAM
    if [ $TOTAL_RAM_GB -ge 16 ]; then
        OPTIMAL_SHM="8g"
    elif [ $TOTAL_RAM_GB -ge 8 ]; then
        OPTIMAL_SHM="4g"
    else
        OPTIMAL_SHM="2g"
    fi
    
    # Set GPU acceleration options
    if [ "$GPU_TYPE" = "nvidia" ]; then
        GPU_OPTIONS="--runtime=nvidia --env NVIDIA_VISIBLE_DEVICES=all --env NVIDIA_DRIVER_CAPABILITIES=all,display"
    elif [ "$GPU_TYPE" = "intel" ] || [ "$GPU_TYPE" = "amd" ]; then
        GPU_OPTIONS="--device /dev/dri:/dev/dri --group-add video"
    else
        GPU_OPTIONS=""
    fi
    
    print_success "Optimal settings calculated"
}

# Display system information
display_system_info() {
    clear
    print_header "System Detection Results"
    
    echo -e "${GREEN}${BOLD}Hardware Information:${NC}"
    echo -e "${CYAN}CPU:${WHITE} $CPU_MODEL"
    echo -e "${CYAN}Cores/Threads:${WHITE} $CPU_CORES cores, $CPU_THREADS threads"
    echo -e "${CYAN}Total RAM:${WHITE} $TOTAL_RAM_GB GB"
    echo -e "${CYAN}Available RAM:${WHITE} $AVAILABLE_RAM_GB GB"
    echo -e "${CYAN}GPU:${WHITE} $GPU_TYPE"
    echo -e "${CYAN}Disk Speed:${WHITE} $DISK_SPEED"
    
    echo -e "\n${GREEN}${BOLD}Network Information:${NC}"
    echo -e "${CYAN}Speed:${WHITE} $NETWORK_SPEED"
    if [ ! -z "$DL_SPEED_MBPS" ]; then
        echo -e "${CYAN}Download:${WHITE} $DL_SPEED_MBPS Mbps"
    fi
    echo -e "${CYAN}Bitrate:${WHITE} $BITRATE"
    echo -e "${CYAN}Buffer:${WHITE} $BUFFER_SIZE"
    
    echo -e "\n${GREEN}${BOLD}Optimal Settings:${NC}"
    echo -e "${CYAN}CPU Cores:${WHITE} $OPTIMAL_CPUS"
    echo -e "${CYAN}RAM:${WHITE} ${OPTIMAL_RAM}GB"
    echo -e "${CYAN}Swap:${WHITE} ${OPTIMAL_SWAP}GB"
    echo -e "${CYAN}Shared Memory:${WHITE} $OPTIMAL_SHM"
    echo -e "${CYAN}GPU Acceleration:${WHITE} $GPU_TYPE"
    
    echo -e "\n${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
    read
}

# Check system requirements
check_system() {
    print_status "Checking system requirements..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check user permissions
    if ! docker info &> /dev/null; then
        print_error "You don't have permission to run Docker. Add your user to the 'docker' group."
        exit 1
    fi
    
    # Check available resources
    if [ "$TOTAL_RAM_KB" -lt 2000000 ]; then
        print_error "Insufficient RAM. At least 2GB is required."
        exit 1
    fi
    
    # Create directories
    mkdir -p "$CONFIG_DIR" "$TEMP_DIR"
    
    print_success "System check passed"
}

# Performance optimization functions
optimize_system() {
    print_status "Applying performance optimizations..."
    
    # Increase shared memory size
    sudo mount -o remount,size=$OPTIMAL_SHM /dev/shm 2>/dev/null || true
    
    # Set swappiness to lower value
    sudo sysctl vm.swappiness=10 2>/dev/null || true
    
    # Optimize disk I/O
    if command -v ionice &> /dev/null; then
        ionice -c 2 -n 0 -p $$ 2>/dev/null || true
    fi
    
    # Enable TCP BBR congestion control if available
    if sysctl net.ipv4.tcp_available_congestion_control | grep -q bbr; then
        sudo sysctl -w net.ipv4.tcp_congestion_control=bbr 2>/dev/null || true
    fi
    
    print_success "Performance optimizations applied"
}

# Browser installation function with performance tweaks
install_browser() {
    local browser_name=$1
    local image_name=$2
    local extra_params=$3
    
    local config_dir="$CONFIG_DIR/$browser_name"
    local port=$((3000 + RANDOM % 1000))
    
    print_header "Installing $browser_name"
    
    # Create browser-specific config directory
    mkdir -p "$config_dir"
    
    # Set up performance-optimized Docker run command
    local docker_cmd="docker run -d \
        --name=${browser_name} \
        --security-opt seccomp=unconfined \
        $GPU_OPTIONS \
        -e PUID=$(id -u) \
        -e PGID=$(id -g) \
        -e TZ=$(cat /etc/timezone 2>/dev/null || echo "UTC") \
        -e FFMPEG_BITRATE=$BITRATE \
        -e FFMPEG_BUFFER=$BUFFER_SIZE \
        -p ${port}:3000 \
        -p $((port+1)):3001 \
        -v ${config_dir}:/config \
        --shm-size=$OPTIMAL_SHM \
        --cpus=$OPTIMAL_CPUS \
        --memory=${OPTIMAL_RAM}g \
        --memory-swap=${OPTIMAL_SWAP}g \
        --restart unless-stopped \
        ${extra_params} \
        ${image_name}"
    
    echo "Command: $docker_cmd" >> "$LOG_FILE"
    
    # Execute the command
    if eval "$docker_cmd" >> "$LOG_FILE" 2>&1; then
        print_success "$browser_name installed successfully!"
        echo -e "${GREEN}Access URL: ${WHITE}http://$(hostname -I | awk '{print $1}'):${port}${NC}"
        echo -e "${GREEN}Config directory: ${WHITE}${config_dir}${NC}"
        echo -e "${GREEN}Allocated resources: ${WHITE}${OPTIMAL_CPUS}CPU, ${OPTIMAL_RAM}GB RAM, ${OPTIMAL_SHM} SHM${NC}"
    else
        print_error "Failed to install $browser_name. Check $LOG_FILE for details."
        return 1
    fi
}

# Display browser selection menu
show_menu() {
    clear
    print_header "LinuxServer.io Browser Installer"
    
    echo -e "${GREEN}${BOLD}Detected System Capabilities:${NC}"
    echo -e "${CYAN}CPU:${WHITE} $OPTIMAL_CPUS cores${NC}"
    echo -e "${CYAN}RAM:${WHITE} ${OPTIMAL_RAM}GB allocated${NC}"
    echo -e "${CYAN}Network:${WHITE} $NETWORK_SPEED speed (${BITRATE} bitrate)${NC}"
    echo -e "${CYAN}GPU:${WHITE} $GPU_TYPE acceleration${NC}"
    
    echo -e "\n${GREEN}${BOLD}Available Browsers:${NC}"
    echo -e "${BLUE}${BOLD}------------------------------------------------${NC}"
    printf "${WHITE}%-3s ${YELLOW}%-20s ${CYAN}%-50s${NC}\n" "ID" "Browser" "Description"
    echo -e "${BLUE}${BOLD}------------------------------------------------${NC}"
    
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "1" "Chromium" "Open-source Chrome variant"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "2" "Firefox" "Mozilla Firefox browser"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "3" "Chrome" "Google Chrome browser"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "4" "Brave" "Privacy-focused Brave browser"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "5" "Opera" "Opera browser with built-in VPN"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "6" "Vivaldi" "Customizable Vivaldi browser"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "7" "Edge" "Microsoft Edge browser"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "8" "Tor Browser" "Anonymous Tor browsing"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "9" "Mullvad Browser" "Privacy browser by Mullvad"
    printf "${GREEN}%-3s ${WHITE}%-20s ${CYAN}%-50s${NC}\n" "10" "Librewolf" "Privacy-focused Firefox fork"
    echo -e "${BLUE}${BOLD}------------------------------------------------${NC}"
    
    echo -e "\n${YELLOW}Enter the browser ID to install (0 to exit):${NC} "
}

# Main installation process
main() {
    # Detect everything automatically
    detect_system_resources
    detect_network_speed
    calculate_optimal_settings
    display_system_info
    check_system
    optimize_system
    
    while true; do
        show_menu
        read -p "Your choice: " choice
        
        case $choice in
            0)
                print_success "Exiting installer. Goodbye!"
                exit 0
                ;;
            1)
                install_browser "chromium" "ghcr.io/linuxserver/chromium:latest" ""
                ;;
            2)
                install_browser "firefox" "ghcr.io/linuxserver/firefox:latest" ""
                ;;
            3)
                install_browser "chrome" "ghcr.io/linuxserver/chrome:latest" ""
                ;;
            4)
                install_browser "brave" "ghcr.io/linuxserver/brave:latest" ""
                ;;
            5)
                install_browser "opera" "ghcr.io/linuxserver/opera:latest" ""
                ;;
            6)
                install_browser "vivaldi" "ghcr.io/linuxserver/vivaldi:latest" ""
                ;;
            7)
                install_browser "edge" "ghcr.io/linuxserver/edge:latest" ""
                ;;
            8)
                install_browser "torbrowser" "ghcr.io/linuxserver/torbrowser:latest" ""
                ;;
            9)
                install_browser "mullvad-browser" "ghcr.io/linuxserver/mullvad-browser:latest" ""
                ;;
            10)
                install_browser "librewolf" "ghcr.io/linuxserver/librewolf:latest" ""
                ;;
            *)
                print_error "Invalid choice. Please try again."
                sleep 2
                continue
                ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue or Ctrl+C to exit...${NC}"
        read
    done
}

# Run main function
main "$@"