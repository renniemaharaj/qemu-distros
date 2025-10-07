#!/data/data/com.termux/files/usr/bin/bash
# Arch Linux under QEMU in Termux (barebones test environment)
# ⚠️ Untested and experimental

set -e

ISO="archlinux-x86_64.iso"
IMG="arch.img"
BOOT="boot.sh"
ISO_URL="https://geo.mirror.pkgbuild.com/iso/latest/${ISO}"

# Ensure QEMU and wget are available
pkg update -y
pkg install -y qemu-system-x86_64-headless qemu-utils wget

# Download Arch ISO if missing
if [ ! -f "$ISO" ]; then
    echo "[*] Downloading Arch Linux ISO..."
    wget "$ISO_URL" -O "$ISO"
fi

# Create disk image if missing
if [ ! -f "$IMG" ]; then
    echo "[*] Creating 4G disk image..."
    qemu-img create -f qcow2 "$IMG" 4G
fi

# Generate boot script
cat > "$BOOT" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
qemu-system-x86_64 \
  -machine q35 \
  -m 2G \
  -smp cpus=2 \
  -cdrom archlinux-x86_64.iso \
  -hda arch.img \
  -boot d \
  -nographic \
  -enable-kvm 2>/dev/null || echo "KVM not available; using emulation mode"
EOF

chmod +x "$BOOT"

echo "[*] Done. Run ./boot.sh to launch Arch Linux ISO installer."
echo "[*] Use your easy-arch scripts inside once booted."
