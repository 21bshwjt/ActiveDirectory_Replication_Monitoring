# ActiveDirectory Replication Monitoring - HTML Email Alert using PowerShell
## Monitoring healthy replication within an Active Directory (AD) forest is essential for all organizations

1. Scheduled tasks need to be created with a Group Managed service account / Service account. An email will be triggered if there is a Replication Error!
2. Refer to this MSFT Blog for gMSA: https://docs.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/getting-started-with-group-managed-service-accounts
3. SMTP variables need to be changed manually from the Code.
```diff
+ Additional feature: That Code will generate the Logs as well so we can track the AD Replication issue for a specific date & time along with the error code.
+ Logs can be sent to the Azure Log Analytics.
```
Refer to this MSFT Blog to Send log data to Azure Monitor by using the HTTP Data Collector API: https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-collector-api?tabs=powershell
