# Threat Modeling & MITRE ATT&CK Detection Engineering Report
**Project Title:** Educational SOC Detection Lab  
**Author / Role:** Member 3 (Offensive Security & Threat Modeler / Red Team Operator)  
**Target Scope:** Central SOC Server (10.10.10.10), Target Webserver (10.10.10.30), Kali Attack VM (10.10.10.40)  

---

## 1. System Architecture & Trust Boundaries

The educational SOC lab establishes an isolated network environment to simulate adversarial actions and validate defensive detection capabilities.

- **Perimeter Boundary:** Controls external SSH access on TCP port 22 from the Red Team (10.10.10.40).
- **Log Ingestion Boundary:** Secure transmission channel forwarding `/var/log/auth.log` to the SOC Server (10.10.10.10).
- **Privilege Boundary:** Governs authorization transitions from standard users to `root` via `/etc/sudoers`.

---

## 2. STRIDE Threat Analysis

| Threat Category | Threat Description | Attack Scenario & MITRE Technique | Impact | Defensive Countermeasure & Mitigation |
| :--- | :--- | :--- | :--- | :--- |
| **Spoofing** | Adversary impersonates legitimate users. | **Scenario A (T1110.001):** SSH password guessing against users (`ubuntu`, `root`). | Unauthorized session establishment, identity theft. | Enforce ED25519 SSH keys; disable password login (`PasswordAuthentication no`). |
| **Tampering** | Modification of system files or audit logs. | **Scenario C (T1548.003):** Modifying `/etc/sudoers` or altering `/var/log/auth.log`. | Compromised audit integrity, unauthorized persistence. | Immutable file attributes (`chattr +a`), real-time off-host log shipping. |
| **Repudiation** | Attacker denies malicious actions. | Local clearing of `~/.bash_history` or killing `rsyslog`. | Inability to attribute attack actions during forensics. | Centralized syslog ingestion with forward-secure buffering. |
| **Information Disclosure** | Leakage of valid internal user accounts. | **Scenario B (T1110):** Probing SSH with common usernames (`admin`, `test`). | Reduced search space for subsequent targeted credential attacks. | Configure `sshd` with generic error messages; rate-limit connection requests. |
| **Denial of Service** | Exhaustion of authentication daemon resources. | High-frequency Hydra brute force overwhelming `sshd` processes. | Legitimate administrators blocked from remote emergency maintenance. | `fail2ban` IP banning, connection rate-limiting via `iptables`. |
| **Elevation of Privilege** | Low-privileged user acquiring `root` control. | **Scenario C (T1548.003):** Unauthorized execution of sudo commands. | Full system compromise, loss of CIA triad. | Least-privilege sudo rules, strict prohibition of wildcard commands. |

---

## 3. MITRE ATT&CK Mapping & Detection Matrix

| MITRE ID | Technique Name | Tactic | Red Team Simulation Tool | Telemetry Source | SOC Detection Rule Logic | Recommended Mitigation |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **T1110.001** | Password Guessing | Credential Access (TA0006) | `hydra -l <user> -P passwords.txt ssh://<IP>` | `/var/log/auth.log`<br/>`sshd[PID]` | Detection of >= 5 consecutive `Failed password for <user>` events within 60s from the same IP. | Disable SSH password logins; deploy Fail2ban. |
| **T1110** | Brute Force (User Enumeration) | Credential Access (TA0006) | `hydra -L users.txt -p <pass> ssh://<IP>` | `/var/log/auth.log`<br/>`sshd[PID]` | Detection of >= 5 distinct `Invalid user <username>` log strings within 60s from the same IP. | Enforce network access control; disable root SSH. |
| **T1548.003** | Sudo & Sudo Caching | Privilege Escalation (TA0004) | `echo <pass> \| sudo -S cat /etc/shadow` | `/var/log/auth.log`<br/>`sudo[PID]` | Alert on log pattern: `user NOT in sudoers` OR >= 3 consecutive `sudo: authentication failure`. | Audit `/etc/sudoers.d/`, deny shell escape binaries. |

---

## 4. Verification & Validation Protocol (Red Team -> Blue Team)

1. **Baseline State:** Confirm SOC Server (`10.10.10.10`) is ingesting baseline auth logs with zero active alerts.
2. **Scenario A Execution:** Run `./01_ssh_bruteforce.sh <Target_IP>`. Verify SOC alert for **MITRE T1110.001**.
3. **Scenario B Execution:** Run `./02_user_enumeration.sh <Target_IP>`. Verify SOC alert for **MITRE T1110**.
4. **Scenario C Execution:** Run `./03_sudo_abuse.sh <Target_IP>`. Verify SOC alert for **MITRE T1548.003**.
