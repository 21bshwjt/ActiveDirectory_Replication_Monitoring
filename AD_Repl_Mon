      <#
.Synopsis
   Active Directory Replication Report
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   N/A
.INPUTS
   Not Required
.OUTPUTS
   Daily Email Notification
.NOTES
   Part of the Code taken from TechNet Forum 
.COMPONENT
    
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
.SOURCE
   Social Technet
.MODIFIER
   Biswajit Biswas | bshwjt@gmail.com
.DATE
   11-Nov-2018
.TESTED
    Windows 2016   | REPADMIN Ver:ProductVersion:10.0.14393.0
    Windows 2012   | REPADMIN Ver:ProductVersion: 6.3.9600.16384
    Windows 2008R2 | REPADMIN Ver:ProductVersion: 6.1.7601.17514
#>
    #Logging
    $VerbosePreference = 'Continue' # Comment this to stop transcript generation
    $dateformat= Get-Date -format 'MM.dd.yyyy.HH.mm.ss' # modified this to reflect the exact time in 24 hour format
    $Subdateformat = Get-Date -format 'MM.dd.yyyy'
    $LoggingDirectory = "C:\Scripts\ADRepl\Logs"
    Start-Transcript -Path "$($LoggingDirectory)\AD_Repl_Status-$($dateformat).log" -Force
     
    # Get the replication info.
    $myRepInfo = @(repadmin /replsum * /bysrc /bydest /sort:delta)
 
    # Initialize our array.
    $cleanRepInfo = @()
    # Start @ #10 because all the previous lines are junk formatting
    # and strip off the last 4 lines because they are not needed.
    for ($i=10; $i -lt ($myRepInfo.Count-4); $i++) {
            if($myRepInfo[$i] -ne ""){
            # Remove empty lines from our array.
            $myRepInfo[$i] -replace '\s+', " "           
            $cleanRepInfo += $myRepInfo[$i]            
            }
            }           
        $finalRepInfo = @()  
            foreach ($line in $cleanRepInfo) {
            $splitRepInfo = $line -split '\s+',8
            if ($splitRepInfo[0] -eq "Source") { $repType = "Source" }
            if ($splitRepInfo[0] -eq "Destination") { $repType = "Destination" }
             
            if ($splitRepInfo[1] -notmatch "DSA") {      
            # Create an Object and populate it with our values.
           $objRepValues = New-Object System.Object
               $objRepValues | Add-Member -type NoteProperty -name DSAType -value $repType # Source or Destination DSA
               $objRepValues | Add-Member -type NoteProperty -name Hostname  -value $splitRepInfo[1] # Hostname
               $objRepValues | Add-Member -type NoteProperty -name Delta  -value $splitRepInfo[2] # Largest Delta
               $objRepValues | Add-Member -type NoteProperty -name Fails -value $splitRepInfo[3] # Failures
               #$objRepValues | Add-Member -type NoteProperty -name Slash  -value $splitRepInfo[4] # Slash char
               $objRepValues | Add-Member -type NoteProperty -name Total -value $splitRepInfo[5] # Totals
               $objRepValues | Add-Member -type NoteProperty -name PctError  -value $splitRepInfo[6] # % errors  
               $objRepValues | Add-Member -type NoteProperty -name ErrorMsg  -value $splitRepInfo[7] # Error code
            
            # Add the Object as a row to our array   
            $finalRepInfo += $objRepValues
             
            }
            }
        $pcterr = $finalRepInfo.PctError
         
        if ($pcterr -ne "0")
        {
            $html = $finalRepInfo | Sort-Object -Descending PctError | ConvertTo-Html -Fragment 
 
             
            $xml = [xml]$html
 
            $attr = $xml.CreateAttribute("id")
            $attr.Value='diskTbl'
            $xml.table.Attributes.Append($attr)
 
 
            $rows=$xml.table.selectNodes('//tr')
            for($i=1;$i -lt $rows.count; $i++){
                $value=$rows.Item($i).LastChild.'#text'
                if($value -ne $null){
                   $attr=$xml.CreateAttribute('style')
                   $attr.Value='background-color: red; color:white;'
                   [void]$rows.Item($i).Attributes.Append($attr)
                }
     
                else {
                   $value
                   $attr=$xml.CreateAttribute('style')
                   $attr.Value='background-color: white;'
                   [void]$rows.Item($i).Attributes.Append($attr)
                }
            }
 
            #embed a CSS stylesheet in the html header
            $html=$xml.OuterXml | Out-String
            $style='<style type=text/css>#diskTbl { background-color: white; } 
            H1{font-family: Calibri, Candara, Segoe, "Segoe UI", Optima, Arial, sans-serif; font-size: 14pt;}
                        P{font-family: Calibri, Candara, Segoe, "Segoe UI", Optima, Arial, sans-serif; font-size: 12pt;}
                        TABLE{border: 1px solid black; border-collapse: collapse; width: 100%}
                        TH{border: 1px solid black; background: #070C4E; padding: 5px; text-align:left; color:#fff;}
                        TD{border: 1px solid black; padding: 5px; }</style>'
 
            $html = ConvertTo-Html -head $style -body $html -Title "Stage Replication Report"
            [string]$htmlMail = ConvertTo-HTML -Head $style -Body $html -PostContent "<h3>Report created on $(Get-Date) from $env:COMPUTERNAME </h3>"
             
            #SMTP Varriables           
            $SMTP = "MAIL.CONTOSO.COM"
            $MailSub = "CONTOSO.COM AD Replication Error | $Subdateformat"
            $To = "ADDS_MON@CONTOSO.COM"
            $FROM = "ADDS_MON@CONTOSO.COM"
            $Sev = "High"
             
            Write-Verbose -Message "Trying to send Email"
            Send-MailMessage -To $To -from $FROM -Subject $MailSub -Body $htmlMail -BodyAsHtml  -SmtpServer $SMTP -Priority $Sev
            Write-Verbose -Message "Having Repl Error"
            Write-Verbose -Message "Sent Email Succesfully"
            }
            else
            {
            Write-Verbose -Message "CONTOSO.COM ADDS Replication is Healthy"
            }
            Stop-Transcript
