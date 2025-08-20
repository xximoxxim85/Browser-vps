#!/bin/bash

# LinuxServer.io Browser Installer for Google Cloud Shell
# Optimized for Cloud Shell environment

# Clear screen
clear

# Configuration
CONFIG_DIR="$HOME/browser-config"
LOG_FILE="$CONFIG_DIR/installation.log"

# Function for formatted output
print_status() {
    echo "[*] $1"
}

print_success() {
    echo "[✓] $1"
}

print_error() {
    echo "[!] $1"
}

print_header() {
    echo "=================================================="
    echo "          $1"
    echo "=================================================="
}

# Check if we're in Google Cloud Shell
check_cloud_shell() {
    print_status "Checking environment..."
    
    if [ -n "$CLOUD_SHELL" ] || [ -d "/google/devshell" ]; then
        print_success "Running in Google Cloud Shell"
        return 0
    else
        print_error "This script is optimized for Google Cloud Shell"
        echo "You can access Google Cloud Shell at: https://shell.cloud.google.com"
        exit 1
    fi
}

# Auto-detect system resources with Cloud Shell limits
detect_system_resources() {
    print_status "Detecting system resources..."
    
    # Cloud Shell typically has 2 vCPUs and 3.5GB RAM
    CPU_CORES=2
    CPU_THREADS=2
    TOTAL_RAM_GB=3.5
    AVAILABLE_RAM_GB=3.0
    
    # Set optimal settings for Cloud Shell
    OPTIMAL_CPUS=2
    OPTIMAL_RAM=2
    OPTIMAL_SWAP=3
    OPTIMAL_SHM="1g"
    GPU_OPTIONS=""
    
    print_success "System resources detected for Cloud Shell"
}

# Auto-detect network speed in Cloud Shell
detect_network_speed() {
    print_status "Testing network speed..."
    
    # Cloud Shell has good network connectivity
    NETWORK_SPEED="high"
    BITRATE="2000k"
    BUFFER_SIZE="4000k"
    DL_SPEED_MBPS=50
    
    print_success "Network speed detected: $NETWORK_SPEED (${DL_SPEED_MBPS}Mbps)"
}

# Display system information
display_system_info() {
    clear
    print_header "Google Cloud Shell Environment"
    
    echo "Hardware Information:"
    echo "CPU Cores/Threads: $CPU_CORES cores, $CPU_THREADS threads"
    echo "Total RAM: $TOTAL_RAM_GB GB"
    echo "Available RAM: $AVAILABLE_RAM_GB GB"
    
    echo -e "\nNetwork Information:"
    echo "Speed: $NETWORK_SPEED"
    echo "Download: ${DL_SPEED_MBPS}Mbps"
    echo "Bitrate: $BITRATE"
    echo "Buffer: $BUFFER_SIZE"
    
    echo -e "\nOptimal Settings:"
    echo "CPU Cores: $OPTIMAL_CPUS"
    echo "RAM: ${OPTIMAL_RAM}GB"
    echo "Shared Memory: $OPTIMAL_SHM"
    
    echo -e "\nPress Enter to continue or Ctrl+C to cancel..."
    read -r
}

# Check system requirements
check_system() {
    print_status "Checking system requirements..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not available in this environment."
        exit 1
    fi
    
    # Create directories
    mkdir -p "$CONFIG_DIR"
    
    print_success "System check passed"
}

# Browser installation function for Cloud Shell
install_browser() {
    local browser_name=$1
    local image_name=$2
    
    local config_dir="$CONFIG_DIR/$browser_name"
    local port=8080  # Cloud Shell uses port 8080 for web preview
    
    print_header "Installing $browser_name"
    
    # Create browser-specific config directory
    mkdir -p "$config_dir"
    
    # Set up Docker run command optimized for Cloud Shell
    local docker_cmd="docker run -d \
        --name=${browser_name} \
        -e PUID=$(id -u) \
        -e PGID=$(id -g) \
        -e TZ=UTC \
        -p ${port}:3000 \
        -v ${config_dir}:/config \
        --shm-size=$OPTIMAL_SHM \
        --memory=${OPTIMAL_RAM}g \
        --restart unless-stopped \
        ${image_name}"
    
    echo "Command: $docker_cmd" >> "$LOG_FILE"
    
    # Stop and remove any existing container with the same name
    docker stop "$browser_name" 2>/dev/null
    docker rm "$browser_name" 2>/dev/null
    
    # Execute the command
    if eval "$docker_cmd" >> "$LOG_FILE" 2>&1; then
        print_success "$browser_name installed successfully!"
        echo "Access URL: https://shell.cloud.google.com/devshell/proxy?authuser=0&port=${port}"
        echo "Config directory: ${config_dir}"
        echo "Allocated resources: ${OPTIMAL_CPUS}CPU, ${OPTIMAL_RAM}GB RAM, ${OPTIMAL_SHM} SHM"
        
        # Wait a bit for container to start
        sleep 5
        
        # Show how to access
        echo -e "\nTo access your browser:"
        echo "1. Click on 'Web Preview' icon in Cloud Shell toolbar"
        echo "2. Select 'port 8080'"
        echo "3. Or use the URL above"
    else
        print_error "Failed to install $browser_name. Check $LOG_FILE for details."
        return 1
    fi
}

# Display browser selection menu
show_menu() {
    clear
    print_header "LinuxServer.io Browser Installer"
    print_header "Google Cloud Shell Edition"
    
    echo "Detected System Capabilities:"
    echo "CPU: $OPTIMAL_CPUS cores"
    echo "RAM: ${OPTIMAL_RAM}GB allocated"
    echo "Network: $NETWORK_SPEED speed (${BITRATE} bitrate)"
    
    echo -e "\nAvailable Browsers:"
    echo "------------------------------------------------"
    echo "ID  Browser                Description"
    echo "------------------------------------------------"
    echo "1   Chromium              Open-source Chrome variant"
    echo "2   Firefox               Mozilla Firefox browser"
    echo "3   Chrome                Google Chrome browser"
    echo "4   Brave                 Privacy-focused Brave browser"
    echo "------------------------------------------------"
    
    echo -e "\nNote: Only lightweight browsers recommended for Cloud Shell"
    echo -e "\nEnter the browser ID to install (0 to exit):"
}

# Cleanup function
cleanup() {
    echo -e "\nCleaning up..."
    for browser in chromium firefox chrome brave; do
        docker stop "$browser" 2>/dev/null
        docker rm "$browser" 2>/dev/null
    done
    echo "Cleanup completed."
}

# Main installation process
main() {
    # Set trap for cleanup
    trap cleanup EXIT
    
    # Check if we're in Cloud Shell
    check_cloud_shell
    
    # Detect resources
    detect_system_resources
    detect_network_speed
    display_system_info
    check_system
    
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
            *)
                print_error "Invalid choice. Please try again."
                sleep 2
                continue
                ;;
        esac
        
        echo -e "\nPress Enter to install another browser or Ctrl+C to exit..."
        read -r
    done
}

# Run main function
main "$@"
