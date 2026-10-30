#!/bin/bash
# ==============================================================================
# Script: run_soc_attacks.sh
# Educational SOC Lab - Red Team Simulation Console
# ==============================================================================

TARGET_IP="10.10.10.30"
LOCAL_IP="10.10.10.40"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${CYAN}==================================================================${NC}"
    echo -e "${BOLD}${YELLOW}   EDUCATIONAL SOC LAB: RED TEAM ATTACK SIMULATION SUITE          ${NC}"
    echo -e "${CYAN}==================================================================${NC}"
    echo -e " Lab Network       : ${BOLD}VirtualBox Internal ('SOC-LAB')${NC}"
    echo -e " Kali Source IP    : ${BOLD}${GREEN}${LOCAL_IP}${NC}"
    echo -e " Current Target IP : ${BOLD}${RED}${TARGET_IP}${NC}"
    echo -e " Known Lab Nodes   : SOC-Server (10.10.10.10) | Web-Server (10.10.10.30)"
    echo -e "                     Employee-PC (10.10.10.20)"
    echo -e "${CYAN}==================================================================${NC}"
}

set_target() {
    echo -e "\nSelect Target:"
    echo -e "  [1] Web-Server  (10.10.10.30)"
    echo -e "  [2] SOC-Server  (10.10.10.10)"
    echo -e "  [3] Employee-PC (10.10.10.20)"
    echo -e "  [4] Custom IP"
    echo -ne "Choice: "
    read -r target_choice
    case $target_choice in
        1) TARGET_IP="10.10.10.30" ;;
        2) TARGET_IP="10.10.10.10" ;;
        3) TARGET_IP="10.10.10.20" ;;
        4) echo -ne "Enter IP: "; read -r custom_ip; TARGET_IP="$custom_ip" ;;
    esac
    echo -e "${GREEN}[✔] Target updated to: ${TARGET_IP}${NC}"
    sleep 1
}

while true; do
    show_banner
    echo -e "  ${BOLD}[1]${NC} Scenario A: SSH Brute Force (MITRE T1110.001)"
    echo -e "  ${BOLD}[2]${NC} Scenario B: SSH User Enumeration (MITRE T1110)"
    echo -e "  ${BOLD}[3]${NC} Scenario C: Sudo Privilege Abuse (MITRE T1548.003)"
    echo -e "  ${BOLD}[4]${NC} Run Full Attack Sequence (A -> B -> C)"
    echo -e "  ${BOLD}[5]${NC} Change Target Host (Current: ${TARGET_IP})"
    echo -e "  ${BOLD}[6]${NC} Exit"
    echo -e "${CYAN}==================================================================${NC}"
    echo -ne "Select option [1-6]: "
    read -r choice

    case $choice in
        1)
            ./01_ssh_bruteforce.sh "$TARGET_IP"
            echo -ne "\nPress Enter to return to menu..."; read -r ;;
        2)
            ./02_user_enumeration.sh "$TARGET_IP"
            echo -ne "\nPress Enter to return to menu..."; read -r ;;
        3)
            ./03_sudo_abuse.sh "$TARGET_IP"
            echo -ne "\nPress Enter to return to menu..."; read -r ;;
        4)
            echo -e "\n${YELLOW}Executing Full Attack Sequence against ${TARGET_IP}...${NC}\n"
            ./01_ssh_bruteforce.sh "$TARGET_IP"
            sleep 2
            ./02_user_enumeration.sh "$TARGET_IP"
            sleep 2
            ./03_sudo_abuse.sh "$TARGET_IP"
            echo -e "\n${GREEN}[✔] All 3 attack scenarios executed!${NC}"
            echo -ne "\nPress Enter to return to menu..."; read -r ;;
        5)
            set_target ;;
        6)
            echo -e "\n${GREEN}Exiting simulation suite.${NC}\n"
            exit 0 ;;
        *)
            echo -e "${RED}[!] Invalid option.${NC}"
            sleep 1 ;;
    esac
done
