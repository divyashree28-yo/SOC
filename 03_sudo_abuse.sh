#!/bin/bash
# ==============================================================================
# Script: 03_sudo_abuse.sh
# MITRE ATT&CK: T1548.003 - Sudo and Sudo Caching Abuse
# ==============================================================================

TARGET_IP="${1:-10.10.10.30}"
SSH_USER="${2:-ubuntu}"

BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}[!] RED TEAM ATTACK SIMULATION: MITRE T1548.003${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "[*] Attack Type     : Unauthorized Sudo Privilege Escalation"
echo -e "[*] Target Host     : ${TARGET_IP}"
echo -e "[*] Simulated User  : ${SSH_USER}"
echo -e "[*] Expected Alert  : 'user NOT in sudoers' / sudo auth failures"
echo -e "${BLUE}====================================================${NC}"

echo -e "\n${GREEN}[+] Executing simulated sudo privilege escalation probes...${NC}\n"

echo -e "${YELLOW}[1/3] Probing sudo privileges (sudo -l)...${NC}"
echo "wrong_password_attempt" | sudo -S -l 2>/dev/null || true

echo -e "${YELLOW}[2/3] Attempting unauthorized access to /etc/shadow...${NC}"
echo "invalid_password" | sudo -S cat /etc/shadow 2>/dev/null || true

echo -e "${YELLOW}[3/3] Generating consecutive sudo authentication failures...${NC}"
for i in {1..3}; do
    echo "bad_pass_$i" | sudo -S id 2>/dev/null || true
    sleep 1
done

echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}[✔] Simulation completed.${NC}"
echo -e "[*] Telemetry emitted to /var/log/auth.log on the target."
echo -e "[*] Inform Member 1 to verify alert: MITRE T1548.003 on SOC Dashboard."
echo -e "${BLUE}====================================================${NC}"
