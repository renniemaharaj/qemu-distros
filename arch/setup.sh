#!/data/data/com.termux/files/usr/bin/bash
# Arch Linux under QEMU in Termux

set -e

ISO="archlinux-x86_64.iso"
IMG="arch.img"
BOOT="boot.sh"
ISO_URL="https://mirror.pkgbuild.com/iso/latest/${ISO}"

pkg update -y
pkg install -y qemu-system-x86_64-headless qemu-utils wget

# Download ISO if missing
if [ ! -f "$ISO" ]; then
    echo "[*] Downloading Arch Linux ISO..."
    wget "$ISO_URL" -O "$ISO"
fi

# Create disk image if missing
if [ ! -f "$IMG" ]; then
    echo "[*] Creating 4G disk image..."
    qemu-img create -f qcow2 "$IMG" 4G
fi

# Boot script
cat > "$BOOT" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
qemu-system-x86_64 \
  -machine q35 \
  -cpu host \
  -m 1G \
  -smp cpus=1 \
  -cdrom archlinux-x86_64.iso \
  -hda arch.img \
  -boot d \
  -nographic \
  -serial mon:stdio
EOF

chmod +x "$BOOT"

echo "[*] Done. Run ./boot.sh to boot Arch Linux ISO."
