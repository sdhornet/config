#!/usr/bin/env bash
# ABOUTME: Network interface status for tmux status bar
# ABOUTME: Shows active interface + IP with priority: tun0 > tailscale > eth0 (public) > eno1

# tun0 — VPN (HTB, pentest engagements)
if ip addr show dev tun0 2>/dev/null | grep -q 'inet '; then
    ip=$(ip -4 addr show dev tun0 | grep -oP 'inet \K[\d.]+')
    echo "#[fg=brightyellow]tun0: $ip"
    exit 0
fi

# tailscale
if command -v tailscale &>/dev/null; then
    if tailscale status 2>/dev/null | grep -q 'offers'; then
        ip=$(ip -4 addr show dev tailscale0 2>/dev/null | grep -oP 'inet \K[\d.]+')
        if [ -n "$ip" ]; then
            echo "#[fg=brightblue]ts0: $ip"
            exit 0
        fi
    fi
fi

# eth0 — public IP only (filter RFC1918)
if ip link show eth0 2>/dev/null | grep -q 'state UP'; then
    ip=$(ip -4 addr show dev eth0 | grep -oP 'inet \K[\d.]+' | grep -v '^10\.' | grep -v '^172\.\(1[6-9]\|2[0-9]\|3[01]\)\.' | grep -v '^192\.168\.' | head -n1)
    if [ -n "$ip" ]; then
        echo "#[fg=red]eth0: $ip"
        exit 0
    fi
fi

# eno1 — fallback physical NIC
if ip link show eno1 2>/dev/null | grep -q 'state UP'; then
    ip=$(ip -4 addr show dev eno1 | grep -oP 'inet \K[\d.]+')
    if [ -n "$ip" ]; then
        echo "#[fg=red]eno1: $ip"
        exit 0
    fi
fi

echo "#[fg=red]no-net"
