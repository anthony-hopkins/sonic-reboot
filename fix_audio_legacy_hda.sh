#!/bin/bash
# Hopkinetic Audio Fixer: Force legacy HDA and disable SOF for Alder Lake-N
# Author: Anthony (via Copilot)
# Purpose: Resolves "Dummy Output" issue by disabling SOF and enabling snd_hda_intel

# Exit immediately if a command exits with a non-zero status
set -e

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to handle errors
error_exit() {
    echo -e "${RED}❌ Error: $1${NC}" >&2
    exit 1
}

# Function to check if running as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        error_exit "This script must be run as root. Use 'sudo $0'"
    fi
}

# Function to check for required commands
check_requirements() {
    local commands=("tee" "update-initramfs" "modprobe")
    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            error_exit "Required command '$cmd' not found. Please install it first."
        fi
    done
}

# Main function
main() {
    echo -e "${YELLOW}🔧 Hopkinetic Audio Fixer: Starting...${NC}"
    
    # Check requirements and permissions
    check_root
    check_requirements
    
    # Step 1: Blacklist SOF modules
    echo -e "${YELLOW}📦 Blacklisting SOF modules...${NC}"
    if ! sudo tee /etc/modprobe.d/blacklist-sof.conf > /dev/null <<EOF
blacklist snd_sof_pci_intel_tgl
blacklist snd_sof
blacklist snd_sof_pci
EOF
    then
        error_exit "Failed to create blacklist configuration"
    fi

    # Step 2: Force legacy HDA driver
    echo -e "${YELLOW}🎯 Forcing legacy HDA driver (dsp_driver=1)...${NC}"
    if ! sudo tee /etc/modprobe.d/alsa-dsp.conf > /dev/null <<EOF
options snd-intel-dspcfg dsp_driver=1
EOF
    then
        error_exit "Failed to create ALSA configuration"
    fi

    # Step 3: Rebuild initramfs
    echo -e "${YELLOW}🧱 Rebuilding initramfs...${NC}"
    if ! sudo update-initramfs -u; then
        error_exit "Failed to update initramfs"
    fi

    # Success message
    echo -e "\n${GREEN}✅ All changes applied successfully!${NC}"
    echo -e "${YELLOW}🔁 Please reboot your system to activate the legacy audio stack:${NC}"
    echo -e "   sudo reboot"
}

# Execute main function
main "$@"
