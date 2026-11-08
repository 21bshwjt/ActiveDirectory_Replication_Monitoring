# Security Policy

## Reporting a vulnerability

Please **do not** open a public issue for security problems.

Report privately via GitHub's [**Report a vulnerability**](https://github.com/21bshwjt/ActiveDirectory_Replication_Monitoring/security/advisories/new) form. You should receive a response within a few days.

## Good practice when deploying

- Run the Scheduled Task under a **gMSA**, not a privileged admin account.
- Restrict NTFS permissions on the script and log folder so only admins can modify the script.
- Log files contain DC hostnames and error details, so treat them as internal data.
