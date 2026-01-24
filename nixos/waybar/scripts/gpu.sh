#!/usr/bin/env bash

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    exit 1
fi

# Query nvidia-smi for GPU stats
# Format: utilization.gpu, memory.used, memory.total, power.draw
stats=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,power.draw --format=csv,noheader,nounits 2>/dev/null)

if [ $? -ne 0 ]; then
    exit 1
fi

# Parse the output
IFS=',' read -r gpu_util mem_used mem_total power_draw <<< "$stats"

# Trim whitespace
gpu_util=$(echo "$gpu_util" | xargs)
mem_used=$(echo "$mem_used" | xargs)
mem_total=$(echo "$mem_total" | xargs)
power_draw=$(echo "$power_draw" | xargs)

# Calculate memory percentage
if [ "$mem_total" -gt 0 ]; then
    mem_percent=$(awk "BEGIN {printf \"%.0f\", ($mem_used / $mem_total) * 100}")
else
    mem_percent=0
fi

# Format values with fixed width and better space efficiency
# GPU util: 2 digits (right-aligned)
# Memory: 2 digits (right-aligned)  
# Power: 4 chars with 1 decimal (e.g., " 5.2", "37.4", "123.4")
gpu_util_fmt=$(printf "%2d" "$gpu_util")
mem_percent_fmt=$(printf "%2d" "$mem_percent")
power_draw_fmt=$(awk "BEGIN {printf \"%4.1f\", $power_draw}")

tooltip="GPU: ${gpu_util}%\nVRAM: ${mem_used}MB / ${mem_total}MB (${mem_percent}%)\nPower: ${power_draw_fmt}W"

# Output JSON for Waybar
echo "{\"text\":\"󰾲${gpu_util_fmt}% ${mem_percent_fmt}% ${power_draw_fmt}W\",\"tooltip\":\"${tooltip}\"}"
