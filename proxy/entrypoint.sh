#!/usr/bin/env bash
set -euo pipefail

IFACE="${AWG_INTERFACE:-awg0}"
CONF="/etc/amnezia/amneziawg/${IFACE}.conf"
CLEAN_CONF="/tmp/${IFACE}.conf"
TABLE="${AWG_TABLE:-51820}"
FWMARK="${AWG_FWMARK:-51820}"
MTU="${AWG_MTU:-1420}"
ENDPOINT_ROUTE=""
AWG_PID=""
SOCKS_PID=""
SOCKS_LISTEN="${SOCKS_LISTEN:-socks5://:1080?udp=true&udpBufferSize=65535}"

if [[ ! -f "$CONF" ]]; then
  echo "ERROR: config not found at $CONF"
  exit 1
fi

cleanup() {
  if [[ -n "$SOCKS_PID" ]]; then
    kill "$SOCKS_PID" 2>/dev/null || true
  fi
  if [[ -n "$AWG_PID" ]]; then
    kill "$AWG_PID" 2>/dev/null || true
  fi
  iptables -t mangle -D POSTROUTING -m mark --mark "$FWMARK" -p udp -j CONNMARK --save-mark 2>/dev/null || true
  iptables -t mangle -D PREROUTING -p udp -j CONNMARK --restore-mark 2>/dev/null || true
  ip link delete "${IFACE}" 2>/dev/null || true
}

trap "cleanup; exit 0" SIGTERM SIGINT

get_value() {
  awk -F= -v key="$1" '
    BEGIN { IGNORECASE = 1 }
    $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
      print $2
      exit
    }
  ' "$CONF" | tr -d '\r'
}

ADDRESS="$(get_value Address)"
DNS="$(get_value DNS)"
MTU="$(get_value MTU || true)"
MTU="${MTU:-${AWG_MTU:-1420}}"
ENDPOINT="$(awk -F= '
  BEGIN { IGNORECASE = 1; in_peer = 0 }
  /^\[Peer\]/ { in_peer = 1; next }
  /^\[/ { in_peer = 0 }
  in_peer && $1 ~ /^[[:space:]]*Endpoint[[:space:]]*$/ {
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
    print $2
    exit
  }
' "$CONF" | tr -d '\r')"

if [[ -z "$ADDRESS" ]]; then
  echo "ERROR: Address is missing in $CONF"
  exit 1
fi

# Strip all fields that awg setconf doesn't understand
sed 's/\r//' "$CONF" \
  | grep -v -iE '^\s*(Address|DNS|MTU|Table|PreUp|PostUp|PreDown|PostDown|SaveConfig)\s*=' \
  > "$CLEAN_CONF"

# Clean up any leftover interface
cleanup

# Start userspace daemon
amneziawg-go "${IFACE}" &
AWG_PID="$!"
sleep 1

# Apply config
awg setconf "${IFACE}" "$CLEAN_CONF"

# Keep the peer endpoint reachable through Docker's bridge after full-tunnel
# policy routing is installed.
if [[ -n "$ENDPOINT" ]]; then
  ENDPOINT_HOST="${ENDPOINT%:*}"
  ENDPOINT_IP="$(getent hosts "$ENDPOINT_HOST" | awk 'NR == 1 { print $1 }')"
  if [[ -n "$ENDPOINT_IP" ]]; then
    GATEWAY="$(ip route show default | awk 'NR == 1 { print $3 }')"
    if [[ -n "$GATEWAY" ]]; then
      ip route replace "$ENDPOINT_IP/32" via "$GATEWAY" dev eth0 2>/dev/null || true
      ENDPOINT_ROUTE="$ENDPOINT_IP/32 via $GATEWAY"
    fi
  fi
fi

# Bring interface up
ip addr add "$ADDRESS" dev "${IFACE}"
ip link set mtu "$MTU" up dev "${IFACE}"

# Set DNS directly
if [[ -n "$DNS" ]]; then
  {
    for ns in ${DNS//,/ }; do
      echo "nameserver $(echo "$ns" | tr -d ' ')"
    done
  } > /etc/resolv.conf
  echo ">>> DNS set to: $DNS"
fi

# Routing
awg set "${IFACE}" fwmark "$FWMARK"
ip rule add not fwmark "$FWMARK" table "$TABLE" 2>/dev/null || true
ip rule add table main suppress_prefixlength 0 2>/dev/null || true
ip route add 0.0.0.0/0 dev "${IFACE}" table "$TABLE" 2>/dev/null || true
iptables -t mangle -C POSTROUTING -m mark --mark "$FWMARK" -p udp -j CONNMARK --save-mark 2>/dev/null \
  || iptables -t mangle -I POSTROUTING -m mark --mark "$FWMARK" -p udp -j CONNMARK --save-mark
iptables -t mangle -C PREROUTING -p udp -j CONNMARK --restore-mark 2>/dev/null \
  || iptables -t mangle -I PREROUTING -p udp -j CONNMARK --restore-mark

if [[ -n "$ENDPOINT_ROUTE" ]]; then
  echo ">>> Endpoint route: $ENDPOINT_ROUTE"
fi
echo ">>> ${IFACE} is up"

gost -L "$SOCKS_LISTEN" &
SOCKS_PID="$!"
echo ">>> SOCKS5 is listening on $SOCKS_LISTEN"

wait "$SOCKS_PID"
