#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gum util-linux e2fsprogs dosfstools gptfdisk cryptsetup

set -euo pipefail

# Detect current devices
ROOT_DEV=$(findmnt -no SOURCE /)
BOOT_DEV=$(findmnt -no SOURCE /boot)
SWAP_DEV=$(swapon --show=NAME --noheadings | head -1 || echo "")

# Normalize /dev/dm-X to /dev/mapper/* paths
if [[ $ROOT_DEV == /dev/dm-* ]]; then
  MAPPER_NAME=$(cat "/sys/block/$(basename "$ROOT_DEV")/dm/name" 2>/dev/null || echo "")
  [ -n "$MAPPER_NAME" ] && ROOT_DEV="/dev/mapper/$MAPPER_NAME"
fi
if [[ -n "$SWAP_DEV" && $SWAP_DEV == /dev/dm-* ]]; then
  MAPPER_NAME=$(cat "/sys/block/$(basename "$SWAP_DEV")/dm/name" 2>/dev/null || echo "")
  [ -n "$MAPPER_NAME" ] && SWAP_DEV="/dev/mapper/$MAPPER_NAME"
fi

# Verification helper
verify() {
  local name=$1 check=$2
  if eval "$check" &>/dev/null; then
    gum style --foreground 42 "✓ $name"
    return 0
  else
    gum style --foreground 196 "✗ $name"
    return 1
  fi
}

# Label LUKS partition helper
label_luks() {
  local device=$1 label=$2
  local luks_name backing disk part_num

  luks_name=$(basename "$device")
  backing=$(sudo cryptsetup status "$luks_name" | grep device: | awk '{print $2}')

  if [[ $backing =~ (.*[^0-9])([0-9]+)$ ]]; then
    disk="${BASH_REMATCH[1]%p}"
    part_num="${BASH_REMATCH[2]}"
    gum spin --spinner dot --title "Labeling $label..." -- \
      sudo sgdisk --change-name="$part_num:$label" "$disk"
  fi
}

# Show header and current setup
gum style --border rounded --padding "1 2" --margin "1" \
  "NixOS Partition Labeling" "" \
  "Will label partitions for generic hardware-configuration.nix"

gum style --margin "1" \
  "Current setup:" \
  "  Boot: $BOOT_DEV" \
  "  Root: $ROOT_DEV" \
  "  Swap: ${SWAP_DEV:-none}"

lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,PARTLABEL,MOUNTPOINT

# Confirm and get sudo
if ! gum confirm "Label partitions now?"; then
  gum style --foreground 208 "Aborted."
  exit 0
fi

echo ""
gum style --foreground 208 "Requesting sudo access..."
sudo -v

# Label filesystems
gum spin --spinner dot --title "Labeling boot partition..." -- \
  sudo fatlabel "$BOOT_DEV" nixos-boot

gum spin --spinner dot --title "Labeling root filesystem..." -- \
  sudo e2label "$ROOT_DEV" nixos-root

[ -n "$SWAP_DEV" ] && gum spin --spinner dot --title "Labeling swap..." -- \
  bash -c "sudo swapoff '$SWAP_DEV' && sudo swaplabel -L nixos-swap '$SWAP_DEV' && sudo swapon '$SWAP_DEV'"

# Label LUKS containers
[[ $ROOT_DEV == /dev/mapper/* ]] && label_luks "$ROOT_DEV" "nixos-crypt-root"
[[ -n "$SWAP_DEV" && $SWAP_DEV == /dev/mapper/* ]] && label_luks "$SWAP_DEV" "nixos-crypt-swap"

# Verify all labels
gum style --foreground 42 --margin "1" "✓ Labeling complete! Verifying..."
echo ""
lsblk -o NAME,SIZE,FSTYPE,LABEL,PARTLABEL,MOUNTPOINT
echo ""
gum style --margin "1" --bold "Verification:"

FAILED=0
verify "Root filesystem: nixos-root" "[ \"\$(sudo e2label '$ROOT_DEV')\" = 'nixos-root' ]" || FAILED=1
verify "Boot partition: nixos-boot" "[ \"\$(sudo fatlabel '$BOOT_DEV')\" = 'nixos-boot' ]" || FAILED=1
[ -n "$SWAP_DEV" ] && { verify "Swap device: nixos-swap" "sudo swaplabel '$SWAP_DEV' | grep -q 'LABEL: nixos-swap'" || FAILED=1; }

# Verify LUKS partition labels (check if they exist, regardless of current mount state)
if [ -d /dev/disk/by-partlabel ]; then
  verify "Root LUKS partition: nixos-crypt-root" "[ -e /dev/disk/by-partlabel/nixos-crypt-root ]" || FAILED=1

  # Check for swap LUKS if we have swap and it looks like LUKS
  if [ -n "$SWAP_DEV" ]; then
    IS_LUKS=0
    [[ $SWAP_DEV == /dev/mapper/* ]] && IS_LUKS=1
    [[ $SWAP_DEV == /dev/dm-* ]] && IS_LUKS=1
    [ $IS_LUKS -eq 1 ] && { verify "Swap LUKS partition: nixos-crypt-swap" "[ -e /dev/disk/by-partlabel/nixos-crypt-swap ]" || FAILED=1; }
  fi
fi

# Show results
echo ""
if [ $FAILED -eq 0 ]; then
  gum style --foreground 42 --border double --padding "1" --margin "1" \
    "✓ All labels verified correctly!" "" \
    "Safe to rebuild NixOS with the generic config."

  gum style --margin "1" --border rounded --padding "1" \
    "Next steps:" \
    "  1. sudo nixos-rebuild test --flake .#NixOS" \
    "  2. sudo nixos-rebuild switch --flake .#NixOS" \
    "  3. sudo reboot"
else
  gum style --foreground 196 --border double --padding "1" --margin "1" \
    "✗ Verification failed!" "" \
    "Some labels are missing or incorrect." \
    "DO NOT rebuild until this is fixed."
  exit 1
fi
