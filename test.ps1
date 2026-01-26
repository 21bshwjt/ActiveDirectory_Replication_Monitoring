# 03. Domain Controller - Conditional Forwaders

$GetDCs = Get-Content ".\DCs_List.txt" -ReadCount 0
$HTMLResult = Invoke-Command -ComputerName $GetDCs -ScriptBlock { Get-CimInstance -Namespace root\MicrosoftDNS -Class MicrosoftDNS_Zone -Filter 'ZoneType = 4' } | 
Where-Object DsIntegrated  -EQ $false | 
Select-Object DnsServerName, Name, MasterServers

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
    #$ExcelPath = ".\Output\Entra_Posture_Management.xlsx"
    if ($HTMLResult ) {
        $HTMLResult | Export-Excel -Path ".\Output\AD_ISPM.xlsx" -WorksheetName $HtmFileName -AutoSize -TableStyle Medium21

    }
    else {
        Write-Host "No data to export to Excel." -ForegroundColor Yellow
    }

    #endregion
}
Else {
    Write-Output "There is no Conditional Forwaders"
}
# End of Conditional Forwadrs
