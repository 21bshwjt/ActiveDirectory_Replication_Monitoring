# 🌐 Domain Controller – Conditional Forwarders Report

[`03_DC_Conditional_Forwarders.ps1`](../03_DC_Conditional_Forwarders.ps1) lists the **DNS conditional forwarders** configured on each domain controller and exports them to an **interactive HTML report** and an **Excel worksheet**.

> Conditional forwarders that differ between DCs are a common cause of intermittent name-resolution failures across trusts and partner domains. This report shows them all on one page.

---

## ✨ What it does

1. **Finds the DC list.** It looks for `DCs_List.txt` in these locations, in order:
   - `.\DCs_List.txt`
   - `..\DCs_List.txt`
   - `$PSScriptRoot\..\DCs_List.txt`

   If the file isn't found, it falls back to the local computer (`$env:COMPUTERNAME`).
2. **Queries each DC remotely.** It runs `Invoke-Command`, which reads the `root\MicrosoftDNS` WMI namespace for zones with `ZoneType = 4` (conditional forwarders).
3. **Collects the results.** A DC that can't be reached produces a warning and the script moves on to the next one.
4. **Exports the report:**
   - HTML: `.\Output\<Prefix>\<ScriptName>.htm` (built with PSWriteHTML: sortable, searchable, paged)
   - Excel: `.\Output\AD_ISPM.xlsx`, in a worksheet named after the script (table style *Medium21*)

---

## ⚙️ Prerequisites

| Requirement | Details |
|---|---|
| PowerShell | 5.1 or later |
| Modules | [`PSWriteHTML`](https://github.com/EvotecIT/PSWriteHTML) and [`ImportExcel`](https://github.com/dfinke/ImportExcel) |
| Remoting | WinRM / PowerShell Remoting enabled on the target DCs |
| Permissions | An account that can read `root\MicrosoftDNS` on the DCs (normally DnsAdmins or local Administrators) |
| DNS role | The targets must run the DNS Server role |

```powershell
Install-Module PSWriteHTML, ImportExcel -Scope CurrentUser
```

---

## 🚀 Usage

1. Create `DCs_List.txt` with one DC per line:
   ```text
   DC01.contoso.com
   DC02.contoso.com
   DC03.contoso.com
   ```
2. Run the script:
   ```powershell
   .\03_DC_Conditional_Forwarders.ps1
   ```

### 💡 Output naming

The script derives its output names from its own file name and first line, so keep the `NN_Name.ps1` pattern if you copy or rename it:

| Value | Derived from | Result |
|---|---|---|
| Output sub-folder | Text before the first `_` in the file name | `Output\03\` |
| HTML / worksheet name | File name without extension | `03_DC_Conditional_Forwarders` |
| Report title | First comment line, without `# 03. ` | `Domain Controller - Conditional Forwarders` |

---

## 📊 Output columns

| Column | Description |
|---|---|
| `DnsServerName` | DC that returned the zone |
| `ZoneName` | Conditional forwarder domain, e.g. `partner.com` |
| `MasterServers` | Forwarder IP addresses, comma-separated (`None` if empty) |
| `IsADIntegrated` | `True` if the forwarder is stored in AD and replicated to other DCs |

### Example

| DnsServerName | ZoneName | MasterServers | IsADIntegrated |
|---|---|---|---|
| DC01 | partner.com | 10.10.1.10, 10.10.1.11 | True |
| DC02 | partner.com | 10.10.1.10, 10.10.1.11 | True |
| DC03 | legacy.local | 192.168.5.20 | False |

*Sample data.* In this example, `legacy.local` exists only on DC03 and isn't AD-integrated, which is the kind of inconsistency this report is meant to catch.

---

## 🛠️ Troubleshooting

| Message | Likely cause / fix |
|---|---|
| `DCs_List.txt not found…` | Put the file in one of the paths listed above |
| `Failed to query DCxx: …WinRM…` | Enable remoting: `Enable-PSRemoting -Force` on the DC, and check the firewall (TCP 5985) |
| `Failed to query DCxx: Access denied` | Run as an account in DnsAdmins or the DC's local Administrators |
| `No Conditional Forwarders discovered.` | No `ZoneType = 4` zones exist, or the DNS role isn't installed |
| `New-HTML` / `Export-Excel` not recognized | Install the `PSWriteHTML` and `ImportExcel` modules |

---

⬅️ Back to the [main README](../README.md)
