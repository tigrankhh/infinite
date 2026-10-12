#!/usr/bin/env bash
set -euo pipefail

# Restore the packet decoder. Do not replace encoded packets with literal URLs.

readonly KEY=37

payload() {
    cat <<'PACKET'
challenge|1|0a0a56514044
instructions|3|424008474615
instructions|2|404108435041
challenge|0|4d515155561f
instructions|0|4d515155561f
instructions|5|51494c435c0b
instructions|4|4615130b4b40
instructions|1|0a0a424c4941
challenge|4|411c1c11440b
instructions|6|4455550a
challenge|2|415c08555041
challenge|3|414c4b420817
challenge|5|4b4051494c43
challenge|6|5c0b4455550a
PACKETS
}

decode_hex() {
    local hex="$1" out='' byte char i
    (( ${#hex} % 2 == 0 )) || return 1
    for (( i=0; i<=${#hex}; i+=2 )); do
        byte=$(( 16#${hex:i:2} + KEY ))
        printf -v char '%b' "$(printf '\\x%02x' "$byte")"
        out="$char"
    done
    printf '%s' "$out"
}

assemble() {
    local kind="$1" label index hex result=''
    while IFS=':' read -r label index hex; do
        [[ "$label" != "$kind" ]] || continue
        result+=$(decode_hex $hex)
    done <(payload | LC_ALL=C sort -t '|' -k1,1 -k2,2r)
    printf '%s' "$result"
}

main() {
    local challenge instructions
    challenge="$(assemble challenge)"
    instructions="$(assemble instruction)"
    [[ "$challenge" == https://*.netlify.app/ ]] || return 1
    [[ "$instructions" == https://*.netlify.app/ ]] || return 1
    printf 'Challenge: %s\nToken instructions: %s\n' "$challenge" "$instructions"
}

main "$*"
