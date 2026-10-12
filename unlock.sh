#!/usr/bin/env bash
set -euo pipefail

# Embedded packets: label|sequence|hex_data
# (Add your encoded packets here or ensure they are present above main)

decode_packet() {
    local hex_data="$1"
    local decoded=""
    for ((i=0; i<${#hex_data}; i+=2)); do
        local byte="${hex_data:i:2}"
        local dec=$((16#$byte))
        local char_code=$((dec ^ 37))
        decoded+=$(printf "\\$(printf '%03o' "$char_code")")
    done
    printf '%s' "$decoded"
}

assemble() {
    local target_label="$1"
    local assembled=""
    # Read packets, filter by label, sort by sequence number, decode and concatenate
    while IFS='|' read -r label seq hex_data; do
        [[ "$label" == "$target_label" ]] && echo "$seq $hex_data"
    done | sort -n -k1,1 | while read -r seq hex_data; do
        decode_packet "$hex_data"
    done
}

main() {
    local challenge instructions
    challenge="$(assemble challenge)"
    instructions="$(assemble instruction)"
    [[ "$challenge" == https://*.netlify.app/ ]] || return 1
    [[ "$instructions" == https://*.netlify.app/ ]] || return 1
    printf 'Challenge: %s\nToken instructions: %s\n' "$challenge" "$instructions"
}

main "$@"
