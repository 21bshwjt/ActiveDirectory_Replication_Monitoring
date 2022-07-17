# ActiveDirectory Replication Monitoring - HTML Email Alert using PowerShell
## Healthy replication in an AD forest is crucial & that needs to monitor for all orgs.

1. Scheduled task need to be created with a Group Managed service account / Service account. Email will be trigged if there is Replication Error !
2. Refer this MSFT Blog for gMSA : https://docs.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/getting-started-with-group-managed-service-accounts
3. SMTP varriables need to change manually from the Code.
```diff
+ 4. Additional feacher : That Code will generate the Logs as well so we can track the AD Replication issue for a specific date & time along-with the error code.
```
