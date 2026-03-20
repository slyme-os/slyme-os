#!/usr/bin/env bash
# Slyme OS — profiledef.sh
# AI-Native Arch Linux Distribution v0.9.9

iso_name="slyme-os"
iso_label="SLYME_OS_099"
iso_publisher="Slyme OS Project <https://slyme-os.github.io>"
iso_application="Slyme OS — AI-Native Linux"
iso_version="0.9.9"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')

declare -A file_permissions=(
  ["/etc/shadow"]="0400 root:root"
  ["/etc/sudoers.d/slyme"]="0440 root:root"
  ["/root/customize_airootfs.sh"]="0755 root:root"
  ["/usr/local/bin/sliwm"]="0755 root:root"
  ["/usr/local/bin/dmenu"]="0755 root:root"
  ["/usr/local/bin/ollama"]="0755 root:root"
  ["/usr/local/bin/slyme-ai"]="0755 root:root"
  ["/usr/local/bin/slyme-session"]="0755 root:root"
  ["/usr/local/bin/slyme-status"]="0755 root:root"
  ["/usr/local/lib/slyme-ai/slyme-ai.py"]="0755 root:root"
  ["/usr/local/lib/slyme-ai/first-boot.sh"]="0755 root:root"
  ["/etc/calamares/launch-calamares.sh"]="0755 root:root"
  ["/etc/skel/.xinitrc"]="0755 root:root"
)
