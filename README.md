# SOC Investigation: SSH Brute-Force Activity
``````
## 1. Project Overview

This project documents a Security Operations Centre (SOC) investigation into suspected SSH brute-force activity on a Linux system.

**Objective:** Identify suspicious authentication attempts, assess the potential risk, and document appropriate investigation and response steps.

**Environment:** Linux lab environment  
**Log source:** SSH authentication logs  
**Tools:** Linux command line, log analysis, and MITRE ATT&CK  
**Project type:** Hands-on lab investigation

## 2. What Is an SSH Brute-Force Attack?

An SSH brute-force attack occurs when an attacker repeatedly attempts to authenticate to a server using different passwords or usernames.

Potential indicators include:
- Multiple failed SSH login attempts.
- Repeated attempts against the same account.
- Attempts involving several usernames.
- Successful authentication following repeated failures.
- Unexpected login activity from an unfamiliar source IP address.

## 3. Investigation Workflow

### Step 1: Review Authentication Logs

On a Linux lab system, review the SSH authentication logs.

Example command for Ubuntu:

```bash
sudo grep -E "Failed password|Accepted password|Invalid user" /var/log/auth.log
```

This command searches for common indicators of failed and successful SSH authentication.

### Step 2: Identify Suspicious Patterns

Review the available evidence for:
- Repeated authentication failures.
- The source IP addresses involved.
- Targeted usernames.
- The time and frequency of attempts.
- Any successful login after repeated failures.

A high number of failures can indicate brute-force activity, but the context must be investigated before confirming malicious intent.

### Step 3: Assess the Risk

Consider the following questions:

1. Did the activity target a privileged account?
2. Were there repeated attempts from one or more source IP addresses?
3. Did any attempt succeed?
4. Was the source IP expected or authorised?
5. Is there evidence of subsequent suspicious activity?

### Step 4: Determine the Outcome

Classify the activity using the available evidence:

- **Confirmed malicious:** Evidence supports unauthorised activity.
- **Suspicious:** Indicators warrant further investigation.
- **Benign or authorised:** Evidence supports a legitimate explanation.
- **Inconclusive:** Insufficient evidence to determine the outcome.

Do not classify an incident as confirmed solely because multiple failed logins occurred.

## 4. MITRE ATT&CK Mapping

- **Tactic:** Credential Access
- **Technique:** T1110 — Brute Force
- **Sub-technique:** T1110.001 — Password Guessing, where applicable

The mapping should reflect the observed behaviour and available evidence.

Reference: https://attack.mitre.org/techniques/T1110/

## 5. Recommended Response

If malicious activity is supported by the evidence:

1. Preserve relevant authentication logs and timestamps.
2. Check for successful logins and suspicious follow-on activity.
3. Validate the source IP and affected accounts.
4. Escalate according to the organisation's incident response procedure.
5. Recommend blocking or restricting confirmed malicious sources where appropriate and authorised.
6. Review SSH access controls, disable unnecessary password authentication where feasible, and enforce strong authentication.
7. Document the investigation and verify remediation.

Avoid blocking an IP address or changing production access controls without appropriate authorisation.

## 6. Evidence and Findings

Record the following after completing the lab investigation:
````



| Evidence | Finding |
|---|---|
| Investigation period | To be documented |
| Source IP address | To be verified |
| Targeted accounts | To be verified |
| Failed login attempts | To be measured |
| Successful authentication | To be checked |
| Final classification | Pending evidence review |

**Note:** No incident conclusion is claimed in this template. Populate the findings using actual lab evidence before presenting the investigation as completed.

## 7. Lessons Learned

This project demonstrates a structured approach to authentication log analysis, identifying suspicious patterns, assessing risk, mapping relevant behaviours to MITRE ATT&CK, and documenting response recommendations.

## 8. Further Improvements

- Add screenshots of relevant authentication logs with sensitive information removed.
- Calculate failed attempts over a defined time window.
- Create a detection query using sample or lab data.
- Document investigation timestamps, evidence, and the final conclusion.




---

## 6. Evidence and Findings

### Lab Environment
- Operating system: Ubuntu Linux
- Hostname: `sarao`
- Log source: SSH service logs using `journalctl`
- Test method: Controlled SSH login attempts against localhost

### Observed Evidence
The SSH logs recorded:
- Invalid username: `invaliduser123`
- Repeated failed password authentication attempts
- PAM authentication failure messages
- Connection closure before successful authentication

### Key Log Evidence
```text
Invalid user invaliduser123 from ::1
authentication failure; rhost=::1
Failed password for invalid user invaliduser123 from ::1
Connection closed by invalid user invaliduser123 ::1 [preauth]
```

### Analysis
The test generated multiple SSH authentication failures. The source address `::1` is the IPv6 loopback address, confirming that the test originated on the same machine.


## Automated SSH Failed-Login Detection

### Objective
Created a Bash script to check SSH authentication logs for failed password attempts within the most recent five minutes.

### Detection Logic
- **Log source:** Linux system journal (`journalctl`)
- **Time window:** Rolling five minutes
- **Threshold:** 5 or more failed-password log entries
- **Alert condition:** Displays an alert when the threshold is reached
- **Below threshold:** Displays `NO ALERT` when fewer than 5 matching entries are found

### Test Result
During a test run, the script reported 0 failed SSH attempts in the last five minutes and correctly displayed `NO ALERT: Below threshold`.

Earlier controlled localhost testing generated failed SSH login events for an invalid username. These were lab-generated events, not evidence of an external attack.

### Limitations
This is a basic, manually executed detection script. It does not continuously monitor logs or send notifications. The threshold is a demonstration rule and would need tuning for a production environment.

### Skills Demonstrated
- Linux command-line investigation
- SSH authentication log analysis
- Bash scripting
- Threshold-based detection logic
- Basic security alert validation
### Final Classification
**Controlled authentication-failure test — not a confirmed malicious incident.**

## Source IP Investigation

### Lab Findings
- **Target hostname:** `sarao`
- **Operating system:** Ubuntu Linux
- **Source IP address:** `10.0.2.15`
- **Network interface:** `enp0s3`
- **Failed SSH password events:** 15
- **First recorded event:** June 24, 21:10:49
- **Last recorded event:** June 24, 21:16:45
- **Time span:** 5 minutes 56 seconds
- **Username attempted:** `fakeuser`
- **Distinct source ports:** 5

### Analysis
The source IP `10.0.2.15` matches the IPv4 address assigned to the Ubuntu VM's `enp0s3` interface. This suggests that the connections originated from the same VM, connecting to its own network interface.

The events span 5 minutes and 56 seconds. These records do not establish that five or more failures occurred within a single five-minute window, nor do they prove malicious intent.

### Classification
**Historical SSH authentication failures — source IP matches the Ubuntu VM; malicious intent not established.**

### Limitations
These are historical journal records. Further investigation is needed to determine the origin of the connections and check for successful authentication or other suspicious activity.

This lab demonstrates SSH log analysis and authentication-failure investigation. Further testing with multiple controlled sessions and a defined time window would be needed to evaluate brute-force detection.



---

## 7. SSH Failed-Login Detection Logic

### Detection Objective
Identify repeated SSH password failures within a defined time window.

### Example Rule
- **Log source:** SSH service logs
- **Event:** `Failed password`
- **Time window:** 5 minutes
- **Example threshold:** 5 or more failures
- **Action:** Generate an alert for analyst investigation

### Lab Test Results
- **Observed events:** 3 failed SSH password log entries
- **Test window:** 18 October 2026, 00:05–00:10
- **Source address:** `::1` (IPv6 loopback)
- **Threshold reached:** No
- **Expected detection result:** No alert

### Analyst Interpretation
The controlled test produced three failed authentication events within the five-minute window. This did not reach the example threshold of five failures.

A real alert would require further investigation of the source, targeted accounts, successful authentication events, and surrounding activity. The threshold is illustrative and should be tuned to the organisation's environment.

**Limitation:** This is a manually executed log-counting exercise, not an automated or continuously running detection rule.

## Source IP Investigation

### Objective
Extract and count source addresses associated with failed SSH password authentication events.

### Command Used
```bash
sudo journalctl -u ssh --since "today" --no-pager | grep "Failed password" | grep -oE 'from [^ ]+' | sort | uniq -c
```

### Lab Finding
- **Source address:** `::1`
- **Failed password events observed:** 3
- **Username:** `invaliduser123`
- **Interpretation:** The events came from the local Ubuntu host during controlled testing.

### Analyst Note
The loopback address `::1` is not evidence of an external attacker. In a real investigation, an analyst would correlate the source address with timestamps, usernames, event frequency, and other security logs before classifying activity as malicious.
## SSH Incident Timeline

| Date and Time | Event | Observation |
|---|---|---|
| Oct 18, 00:08:55 | Failed login 1 | Invalid username `invaliduser123` |
| Oct 18, 00:09:05 | Failed login 2 | 10 seconds after the first event |
| Oct 18, 00:09:13 | Failed login 3 | 8 seconds after the second event |

### Timeline Analysis
Three failed-password events occurred within 18 seconds. All observed events came from the IPv6 loopback address `::1`, indicating local lab testing. The events demonstrate repeated authentication failures but do not, by themselves, establish an external brute-force attack.

### Evidence Source
Linux SSH service logs collected using `journalctl` and filtered for `Failed password` entries.


---

**Portfolio:** [My GitHub Profile](https://github.com/surinenianwesh)
