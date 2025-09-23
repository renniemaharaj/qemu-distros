#!/data/data/com.termux/files/usr/bin/bash
# Alpine Linux under QEMU in Termux

set -e

ISO="alpine-virt-3.22.0-x86_64.iso"
IMG="alpine.img"
BOOT="boot.sh"
ISO_URL="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/${ISO}"

pkg update -y
pkg install -y qemu-system-x86_64-headless qemu-utils wget

# Download ISO if missing
if [ ! -f "$ISO" ]; then
    echo "[*] Downloading Alpine ISO..."
    wget "$ISO_URL" -O "$ISO"
fi

# Create disk image if missing
if [ ! -f "$IMG" ]; then
    echo "[*] Creating 2G disk image..."
    qemu-img create -f qcow2 "$IMG" 2G
fi

# Boot script
cat > "$BOOT" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
qemu-system-x86_64 \
  -machine q35 \
  -m 1G \
  -smp cpus=1 \
  -cdrom alpine-virt-3.22.0-x86_64.iso \
  -hda alpine.img \
  -boot d \
  -nographic
EOF
chmod +x "$BOOT"

echo "[*] Done. Run ./boot.sh to install Alpine Linux."
