#!/data/data/com.termux/files/usr/bin/bash
# Ubuntu Server under QEMU in Termux

set -e

# Environment & variables
ISO="ubuntu-24.04.3-live-server-amd64.iso"
IMG="ubuntu.img"
BOOT="boot.sh"
ISO_URL="https://releases.ubuntu.com/24.04/${ISO}"

# 1. Install deps
pkg update -y
pkg install -y qemu-system-x86_64-headless qemu-utils wget

# 2. Download ISO if missing
if [ ! -f "$ISO" ]; then
    echo "[*] Downloading Ubuntu ISO..."
    wget "$ISO_URL" -O "$ISO"
fi

# 3. Create disk image if missing
if [ ! -f "$IMG" ]; then
    echo "[*] Creating 8G disk image..."
    qemu-img create -f qcow2 "$IMG" 8G
fi

# 4. Boot script (install mode)
cat > "$BOOT" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
qemu-system-x86_64 \
  -machine q35 \
  -m 2G \
  -smp cpus=2 \
  -cdrom ubuntu-24.04.3-live-server-amd64.iso \
  -hda ubuntu.img \
  -boot d \
  -nographic

EOF
chmod +x "$BOOT"

echo "[*] Done. Run ./boot.sh to install Ubuntu Server."