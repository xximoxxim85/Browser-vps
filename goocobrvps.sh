#!/bin/bash

# Enhanced LinuxServer.io Browser Installer with Auto-Detection
# Fixed version without formatting issues

# Clear screen and set trap
clear
trap 'echo -e "\nScript interrupted. Cleaning up..."; exit 1' SIGINT SIGQUIT SIGTSTP

# Configuration
CONFIG_DIR="$HOME/browser-config"
LOG_FILE="$CONFIG_DIR/installation.log"
TEMP_DIR="/tmp/browser-installer"

# Function for formatted output
print_status() {
    echo -e "[*] $1"
}

print_success() {
    echo -e "[✓] $1"
}

print_error() {
    echo -e "[!] $1"
}

print_header() {
    echo -e "=================================================="
    echo -e "          $1"
    echo -e "=================================================="
}

# Auto-detect system resources
detect_system_resources() {
    print_status "Detecting system resources..."
    
    # CPU detection
    CPU_CORES=$(nproc 2>/dev/null || echo 2)
    CPU_THREADS=$(grep -c "processor" /proc/cpuinfo 2>/dev/null || echo 2)
    
    # RAM detection
    TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || echo 2097152)
    TOTAL_RAM_GB=$((TOTAL_RAM_KB / 1024 / 1024))
    AVAILABLE_RAM_KB=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}' || echo 1572864)
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
    
    print_success "System resources detected"
}

# Auto-detect network speed
detect_network_speed() {
    print_status "Testing network speed..."
    
    # Default values
    NETWORK_SPEED="medium"
    BITRATE="1500k"
    BUFFER_SIZE="3000k"
    DL_SPEED_MBPS=15
    
    # Try to detect network speed using curl
    TEST_URL="http://cachefly.cachefly.net/10mb.test"
    
    if command -v curl > /dev/null; then
        START_TIME=$(date +%s)
        curl -o /dev/null -s -w "%{speed_download}" "$TEST_URL" > "$TEMP_DIR/curl_speed.txt" 2>/dev/null &
        CURL_PID=$!
        sleep 3
        
        if kill -0 "$CURL_PID" 2>/dev/null; then
            kill "$CURL_PID" 2>/dev/null
        else
            DL_SPEED=$(cat "$TEMP_DIR/curl_speed.txt" 2>/dev/null || echo "0")
            DL_SPEED_MBPS=$(echo "scale=2; $DL_SPEED / 125000" | bc 2>/dev/null || echo 15)
            
            if (( $(echo "$DL_SPEED_MBPS > 50" | bc -l 2>/dev/null) )); then
                NETWORK_SPEED="very_high"
                BITRATE="5000k"
                BUFFER_SIZE="10000k"
            elif (( $(echo "$DL_SPEED_MBPS > 25" | bc -l 2>/dev/null) )); then
                NETWORK_SPEED="high"
                BITRATE="3000k"
                BUFFER_SIZE="6000k"
            elif (( $(echo "$DL_SPEED_MBPS > 10" | bc -l 2>/dev/null) )); then
                NETWORK_SPEED="medium"
                BITRATE="1500k"
                BUFFER_SIZE="3000k"
            elif (( $(echo "$DL_SPEED_MBPS > 5" | bc -l 2>/dev/null) )); then
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
    
    print_success "Network speed detected: $NETWORK_SPEED (${DL_SPEED_MBPS}Mbps)"
}

# Calculate optimal settings based on system resources
calculate_optimal_settings() {
    print_status "Calculating optimal settings..."
    
    # Calculate CPU allocation (use 75% of available cores, min 2, max 8)
    OPTIMAL_CPUS=$((CPU_THREADS * 3 / 4))
    if [ "$OPTIMAL_CPUS" -lt 2 ]; then
        OPTIMAL_CPUS=2
    elif [ "$OPTIMAL_CPUS" -gt 8 ]; then
        OPTIMAL_CPUS=8
    fi
    
    # Calculate RAM allocation (use 70% of available RAM, min 2GB, max 16GB)
    OPTIMAL_RAM=$((AVAILABLE_RAM_KB * 70 / 100 / 1024 / 1024))
    if [ "$OPTIMAL_RAM" -lt 2 ]; then
        OPTIMAL_RAM=2
    elif [ "$OPTIMAL_RAM" -gt 16 ]; then
        OPTIMAL_RAM=16
    fi
    
    # Calculate swap allocation (1.5x RAM)
    OPTIMAL_SWAP=$((OPTIMAL_RAM * 3 / 2))
    
    # Calculate SHM size based on RAM
    if [ "$TOTAL_RAM_GB" -ge 16 ]; then
        OPTIMAL_SHM="8g"
    elif [ "$TOTAL_RAM_GB" -ge 8 ]; then
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
    
    echo -e "Hardware Information:"
    echo -e "CPU Cores/Threads: $CPU_CORES cores, $CPU_THREADS threads"
    echo -e "Total RAM: $TOTAL_RAM_GB GB"
    echo -e "Available RAM: $AVAILABLE_RAM_GB GB"
    echo -e "GPU: $GPU_TYPE"
    
    echo -e "\nNetwork Information:"
    echo -e "Speed: $NETWORK_SPEED"
    echo -e "Download: ${DL_SPEED_MBPS}Mbps"
    echo -e "Bitrate: $BITRATE"
    echo -e "Buffer: $BUFFER_SIZE"
    
    echo -e "\nOptimal Settings:"
    echo -e "CPU Cores: $OPTIMAL_CPUS"
    echo -e "RAM: ${OPTIMAL_RAM}GB"
    echo -e "Swap: ${OPTIMAL_SWAP}GB"
    echo -e "Shared Memory: $OPTIMAL_SHM"
    echo -e "GPU Acceleration: $GPU_TYPE"
    
    echo -e "\nPress Enter to continue or Ctrl+C to cancel..."
    read -r
}

# Check system requirements
check_system() {
    print_status "Checking system requirements..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        echo "You can install Docker with: sudo apt-get install docker.io"
        exit 1
    fi
    
    # Check user permissions
    if ! docker info &> /dev/null; then
        print_error "You don't have permission to run Docker. Add your user to the 'docker' group."
        echo "You can do this with: sudo usermod -aG docker $USER"
        echo "Then log out and log back in for the changes to take effect."
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
    sudo mount -o remount,size="$OPTIMAL_SHM" /dev/shm 2>/dev/null || true
    
    # Set swappiness to lower value
    sudo sysctl vm.swappiness=10 2>/dev/null || true
    
    print_success "Performance optimizations applied"
}

# Browser installation function with performance tweaks
install_browser() {
    local browser_name=$1
    local image_name=$2
    
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
        ${image_name}"
    
    echo "Command: $docker_cmd" >> "$LOG_FILE"
    
    # Execute the command
    if eval "$docker_cmd" >> "$LOG_FILE" 2>&1; then
        print_success "$browser_name installed successfully!"
        echo -e "Access URL: http://localhost:${port}"
        echo -e "Config directory: ${config_dir}"
        echo -e "Allocated resources: ${OPTIMAL_CPUS}CPU, ${OPTIMAL_RAM}GB RAM, ${OPTIMAL_SHM} SHM"
    else
        print_error "Failed to install $browser_name. Check $LOG_FILE for details."
        return 1
    fi
}

# Display browser selection menu
show_menu() {
    clear
    print_header "LinuxServer.io Browser Installer"
    
    echo -e "Detected System Capabilities:"
    echo -e "CPU: $OPTIMAL_CPUS cores"
    echo -e "RAM: ${OPTIMAL_RAM}GB allocated"
    echo -e "Network: $NETWORK_SPEED speed (${BITRATE} bitrate)"
    echo -e "GPU: $GPU_TYPE acceleration"
    
    echo -e "\nAvailable Browsers:"
    echo -e "------------------------------------------------"
    echo -e "ID  Browser                Description"
    echo -e "------------------------------------------------"
    echo -e "1   Chromium              Open-source Chrome variant"
    echo -e "2   Firefox               Mozilla Firefox browser"
    echo -e "3   Chrome                Google Chrome browser"
    echo -e "4   Brave                 Privacy-focused Brave browser"
    echo -e "5   Opera                 Opera browser with built-in VPN"
    echo -e "6   Vivaldi               Customizable Vivaldi browser"
    echo -e "7   Edge                  Microsoft Edge browser"
    echo -e "8   Tor Browser           Anonymous Tor browsing"
    echo -e "9   Mullvad Browser       Privacy browser by Mullvad"
    echo -e "10  Librewolf             Privacy-focused Firefox fork"
    echo -e "------------------------------------------------"
    
    echo -e "\nEnter the browser ID to install (0 to exit):"
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
        read -r -p "Your choice: " choice
        
        case $choice in
            0)
                print_success "Exiting installer. Goodbye!"
                exit 0
                ;;
            1)
                install_browser "chromium" "ghcr.io/linuxserver/chromium:latest"
                ;;
            2)
                install_browser "firefox" "ghcr.io/linuxserver/firefox:latest"
                ;;
            3)
                install_browser "chrome" "ghcr.io/linuxserver/chrome:latest"
                ;;
            4)
                install_browser "brave" "ghcr.io/linuxserver/brave:latest"
                ;;
            5)
                install_browser "opera" "ghcr.io/linuxserver/opera:latest"
                ;;
            6)
                install_browser "vivaldi" "ghcr.io/linuxserver/vivaldi:latest"
                ;;
            7)
                install_browser "edge" "ghcr.io/linuxserver/edge:latest"
                ;;
            8)
                install_browser "torbrowser" "ghcr.io/linuxserver/torbrowser:latest"
                ;;
            9)
                install_browser "mullvad-browser" "ghcr.io/linuxserver/mullvad-browser:latest"
                ;;
            10)
                install_browser "librewolf" "ghcr.io/linuxserver/librewolf:latest"
                ;;
            *)
                print_error "Invalid choice. Please try again."
                sleep 2
                continue
                ;;
        esac
        
        echo -e "\nPress Enter to continue or Ctrl+C to exit..."
        read -r
    done
}

# Run main function
main "$@"
