#!/data/data/com.termux/files/usr/bin/bash
# Debian 12.3.0 Server under QEMU in Termux

set -e

ISO="debian-13.1.0-amd64-netinst.iso"
IMG="debian.img"
BOOT="boot-debian.sh"
ISO_URL="https://cdimage.debian.org/cdimage/release/13.1.0/amd64/iso-cd/${ISO}"

pkg update -y
pkg install -y qemu-system-x86_64-headless qemu-utils wget

# Download ISO if missing
if [ ! -f "$ISO" ]; then
    echo "[*] Downloading Debian ISO..."
    wget "$ISO_URL" -O "$ISO"
fi

# Create disk image if missing
if [ ! -f "$IMG" ]; then
    echo "[*] Creating 8G disk image..."
    qemu-img create -f qcow2 "$IMG" 8G
fi

# Boot script
cat > "$BOOT" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
qemu-system-x86_64 \
  -machine q35 \
  -m 2G \
  -smp cpus=2 \
  -cdrom debian-12.3.0-amd64-netinst.iso \
  -hda debian.img \
  -boot d \
  -nographic
EOF
chmod +x "$BOOT"

echo "[*] Done. Run ./boot-debian.sh to install Debian Server."
