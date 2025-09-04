#!/bin/bash
# Hopkinetic Audio Fixer: Force legacy HDA and disable SOF for Alder Lake-N
# Author: Anthony (via Copilot)
# Purpose: Resolves "Dummy Output" issue by disabling SOF and enabling snd_hda_intel

set -e

echo "🔧 Hopkinetic Audio Fixer: Starting..."

# Step 1: Blacklist SOF modules
echo "📦 Blacklisting SOF modules..."
sudo tee /etc/modprobe.d/blacklist-sof.conf > /dev/null <<EOF
blacklist snd_sof_pci_intel_tgl
blacklist snd_sof
blacklist snd_sof_pci
EOF

# Step 2: Force legacy HDA driver
echo "🎯 Forcing legacy HDA driver (dsp_driver=1)..."
sudo tee /etc/modprobe.d/alsa-dsp.conf > /dev/null <<EOF
options snd-intel-dspcfg dsp_driver=1
EOF

# Step 3: Rebuild initramfs
echo "🧱 Rebuilding initramfs..."
sudo update-initramfs -u

# Step 4: Prompt for reboot
echo -e "\n✅ All changes applied. Please reboot to activate legacy audio stack."
echo "🔁 Run: sudo reboot"
