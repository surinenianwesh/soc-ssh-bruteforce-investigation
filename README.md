# SOC Investigation: SSH Brute-Force Activity

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

**Portfolio:** [My GitHub Profile](https://github.com/surinenianwesh)
