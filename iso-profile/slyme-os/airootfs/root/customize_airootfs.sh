#!/usr/bin/env bash
# Slyme OS — airootfs customisation script
# Runs in chroot during mkarchiso build
set -e

echo "[slyme-os] Running customize_airootfs.sh..."

# Set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Generate locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Set hostname
echo "slyme-os" > /etc/hostname
cat > /etc/hosts << 'HOSTS'
127.0.0.1   localhost
::1         localhost
127.0.1.1   slyme-os.localdomain slyme-os
HOSTS

# Set default shell to zsh
chsh -s /bin/zsh root

# Create live user 'slyme'
useradd -m -G wheel,audio,video,storage,optical,network,power \
        -s /bin/zsh \
        -c "Slyme OS Live User" \
        slyme

# Set password 'slyme' for both root and slyme user
echo "root:slyme" | chpasswd
echo "slyme:slyme" | chpasswd

# Copy skel to slyme's home (useradd -m should do this but be explicit)
cp -rT /etc/skel /home/slyme
chown -R slyme:slyme /home/slyme

# Make .xinitrc executable
chmod +x /home/slyme/.xinitrc

# Enable NetworkManager
systemctl enable NetworkManager.service

# Enable Ollama service
systemctl enable ollama.service

# Enable slyme-ai service
systemctl enable slyme-ai.service

# Set zsh as default for slyme user
chsh -s /bin/zsh slyme

echo "[slyme-os] customize_airootfs.sh complete."

# Ensure all Slyme OS binaries are executable
chmod +x /usr/local/bin/sliwm
chmod +x /usr/local/bin/slyme-ai
chmod +x /usr/local/bin/slyme-status
chmod +x /usr/local/bin/slyme-session
chmod +x /usr/local/bin/ollama
chmod +x /usr/local/bin/dmenu
chmod +x /usr/local/lib/slyme-ai/slyme-ai.py
chmod +x /usr/local/lib/slyme-ai/first-boot.sh
chmod +x /etc/calamares/launch-calamares.sh
chmod +x /etc/skel/.xinitrc

# Fix home directory permissions
chmod +x /home/slyme/.xinitrc 2>/dev/null || true
