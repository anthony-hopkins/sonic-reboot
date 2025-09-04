# Audio Fix for Alder Lake-N on Linux

This project provides a solution to fix audio issues (specifically "Dummy Output" problems) on Alder Lake-N systems running Linux by forcing the legacy HDA audio driver and disabling the Sound Open Firmware (SOF) driver.

## Problem

Some Alder Lake-N based systems experience audio output issues where the system only shows "Dummy Output" in the sound settings. This happens because the system may incorrectly use the SOF driver instead of the legacy HDA driver.

## Solution

This script automates the process of:
1. Blacklisting the SOF modules
2. Forcing the system to use the legacy HDA audio driver
3. Rebuilding the initramfs to apply the changes

## Prerequisites

- Linux distribution (tested on Ubuntu/Debian-based systems)
- Sudo/root access
- Alder Lake-N based system experiencing audio issues

## Usage

1. Make the script executable:
   ```bash
   chmod +x sonic_reboot/fix_audio_legacy_hda.sh
   ```

2. Run the script with sudo:
   ```bash
   sudo ./sonic_reboot/fix_audio_legacy_hda.sh
   ```

3. Reboot your system when prompted:
   ```bash
   sudo reboot
   ```

## What the Script Does

1. **Blacklists SOF modules** by creating `/etc/modprobe.d/blacklist-sof.conf`
2. **Forces legacy HDA driver** by creating `/etc/modprobe.d/alsa-dsp.conf`
3. **Rebuilds initramfs** to ensure changes persist across reboots
4. **Prompts for reboot** to apply the changes

## Reverting Changes

If you experience any issues or want to revert to the default configuration:

1. Remove the configuration files:
   ```bash
   sudo rm /etc/modprobe.d/blacklist-sof.conf
   sudo rm /etc/modprobe.d/alsa-dsp.conf
   ```

2. Rebuild initramfs:
   ```bash
   sudo update-initramfs -u
   ```

3. Reboot your system

## Author

anthony.hopkins@hopkinetic.com

## License

This project is open source and available under the [MIT License](LICENSE).

## Disclaimer

This script is provided as-is, without any warranties. Use it at your own risk. Always back up your system before making system-level changes.
