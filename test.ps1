# 03. Domain Controller - Conditional Forwaders

try {
    # Discovery logic for DCs_List.txt
    $DCListPaths = @(".\DCs_List.txt", "..\DCs_List.txt", "$PSScriptRoot\..\DCs_List.txt")
    $DCListPath = $null
    foreach ($path in $DCListPaths) {
        if (Test-Path $path) {
            $DCListPath = $path
            break
        }
    }

    if ($DCListPath) {
        $GetDCs = Get-Content $DCListPath -ReadCount 0
    }
    else {
        Write-Warning "DCs_List.txt not found in expected locations. Using localhost as fallback."
        $GetDCs = @($env:COMPUTERNAME)
    }

    $HTMLResult = @()

    foreach ($DC in $GetDCs) {
        try {
            Write-Host "Checking Conditional Forwarders on: $DC" -ForegroundColor Cyan
            $dcResults = Invoke-Command -ComputerName $DC -ScriptBlock { 
                # Attempt to get zones of type 4 (Forwarder)
                Get-CimInstance -Namespace root\MicrosoftDNS -Class MicrosoftDNS_Zone -Filter 'ZoneType = 4' -ErrorAction SilentlyContinue | 
                Select-Object @{Name = 'DnsServerName'; Expression = { $env:COMPUTERNAME } }, Name, MasterServers, DsIntegrated
            } -ErrorAction Stop

            if ($dcResults) {
                foreach ($item in $dcResults) {
                    $HTMLResult += [PSCustomObject]@{
                        DnsServerName  = $item.DnsServerName
                        ZoneName       = $item.Name
                        MasterServers  = if ($item.MasterServers) { $item.MasterServers -join ", " } else { "None" }
                        IsADIntegrated = $item.DsIntegrated
                    }
                }
            }
        }
        catch {
            Write-Warning "Failed to query ${DC}: $($_.Exception.Message)"
        }
    }

    if ($HTMLResult) {
        #region Outputs
        $Ps1FileName = $($MyInvocation.MyCommand.Name)
        $DirName = ($Ps1FileName -split "_")[0]
        $HtmFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

        # Ensure the output directory exists
        $OutputDir = ".\Output\$DirName"
        if (!(Test-Path $OutputDir)) {
            [void](New-Item -ItemType Directory -Path $OutputDir -Force)
        }

        $FirstLine = Get-Content $MyInvocation.MyCommand.Path | Select-Object -First 1
        $Title = $FirstLine -replace '^#\s*\d+\.\s*', ''

        # Output the HTML results
        $date = (Get-Date).ToString('MM-dd-yyyy')
        $headertxt = "<H2><Center>$Title | $date </Center></H2>"
        $TableTitle = $Title
        New-HTML -TitleText $Title {
            New-HTMLContent -HeaderText "<center>$headertxt</center>" {
                New-HTMLTable -Title $TableTitle -DataTable $HTMLResult -HideFooter -PagingOptions @(500, 1000, 1500) {

                } 
            }
        } -FilePath ".\Output\$DirName\$HtmFileName.htm"

        # Export to Excel
        if ($HTMLResult) {
            $HTMLResult | Export-Excel -Path ".\Output\AD_ISPM.xlsx" -WorksheetName $HtmFileName -AutoSize -TableStyle Medium21
        }
        #endregion
    }
    else {
        Write-Output "No Conditional Forwarders discovered."
    }
}
catch {
    Write-Error "Error in 03_DC_Cond_Forwaders: $($_.Exception.Message)"
}
# End of Conditional Forwadrs
# End of Conditional Forwadrs
