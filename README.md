# 🔁 Active Directory Replication Monitoring
### HTML Email Alerts via PowerShell

> Proactively monitor AD replication health across your entire forest — get instant email alerts on failures, with full logging and Azure Monitor integration.

---

## 📋 Overview

Maintaining healthy replication within an **Active Directory (AD) forest** is critical for every organization. This PowerShell solution automates replication health checks and delivers rich **HTML-formatted email alerts** the moment a replication error is detected — so your team can respond before users are impacted.

---

## ✨ Features

- 📧 **HTML Email Alerts** — Beautiful, readable alert emails triggered automatically on replication errors
- 📝 **Local Log Generation** — Tracks AD replication issues with date, time, and error codes for historical review
- ☁️ **Azure Log Analytics Integration** — Forwards logs to Azure Monitor via the HTTP Data Collector API for centralized visibility
- 🔐 **gMSA Support** — Designed to run securely under a Group Managed Service Account or standard Service Account

---

## ⚙️ Prerequisites

| Requirement | Details |
|---|---|
| PowerShell | Version 5.1 or later |
| Permissions | Domain Admin or delegated replication monitoring rights |
| Service Account | gMSA or standard Service Account for Scheduled Task |
| SMTP Server | Internal relay or external SMTP endpoint |

---

## 🚀 Setup

### 1. Configure the Scheduled Task

Create a Windows Scheduled Task using a **Group Managed Service Account (gMSA)** or a standard Service Account to run the script on your desired interval.

> 📖 **Reference:** [Getting Started with Group Managed Service Accounts](https://docs.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/getting-started-with-group-managed-service-accounts) — Microsoft Docs

### 2. Update SMTP Variables

Before deploying, update the SMTP configuration block inside the script with your environment's mail relay settings:

```powershell
# ── SMTP Configuration ──────────────────────────────────────────
$smtpServer   = "smtp.yourdomain.com"
$smtpPort     = 587
$mailFrom     = "ad-monitor@yourdomain.com"
$mailTo       = "it-alerts@yourdomain.com"
$mailSubject  = "⚠️ AD Replication Error Detected"
# ────────────────────────────────────────────────────────────────
```

### 3. (Optional) Enable Azure Log Analytics

To ship replication logs to **Azure Monitor**, configure your Workspace ID and Shared Key in the script. Logs will be forwarded via the HTTP Data Collector API.

> 📖 **Reference:** [Send log data to Azure Monitor using the HTTP Data Collector API](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-collector-api?tabs=powershell) — Microsoft Docs

---

## 📂 Log Output

Each script execution appends a structured log entry containing:

- ✅ Timestamp (date & time)
- 🖥️ Source & Destination Domain Controller
- ❌ Error Code & Description
- 🌐 Replication Partner Site

Logs are stored locally and optionally forwarded to your **Azure Log Analytics Workspace** for querying with KQL.

---

## 📬 How It Works

```
Scheduled Task triggers PowerShell script
        │
        ▼
Run repadmin /showrepl or Get-ADReplicationFailure
        │
        ├── No errors found → Log "Healthy" entry, exit
        │
        └── Errors detected → Generate HTML email body
                                      │
                                      ├── Send alert email via SMTP
                                      │
                                      └── Write log entry (local + Azure Monitor)
```

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
