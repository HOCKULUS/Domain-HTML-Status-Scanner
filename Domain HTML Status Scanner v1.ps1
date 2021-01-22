##[Ps1 To Exe]
##
##NcDBCIWOCzWE8pGP3wFk4Fn9fnwkbMyaqvivwYiy+tbIvjbSXZUEdWFFuhroBV+oStEdUfBbpMIcBH0=
##NcDBCIWOCzWE8pGP3wFk4Fn9fnwkbMyaqvivwYiy+tbIvjbSXZUEdUN4hD3wDVipF+YKQZU=
##Kd3HDZOFADWE8uO1
##Nc3NCtDXTlaDjofG5iZk2V/hQGEqfYuTvL+pwb2Y8P3ityrYTYkoTVt6lyDySVm4XvsBQeccscMEWxpkJvEEgg==
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4tI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWI0g==
##OsfOAYaPHGbQvbyVvnQmqxuO
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnRT6kbvS2ZrRvG2lfaU0ICo6vmsiCbYR5QRWzQ=
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8r/c8SFj7QXqRwg=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjofG5iZk2V/hQGEqfYuTvL+pwb2Y+vnnryrJdb4bRFV+mGnUMGaRGcEGVOEAp5EiVhwkIfcZoqSBVeKxQMI=
##Kc/BRM3KXhU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
cls
write-host "Icon von https://www.freepik.com"
start-sleep -Milliseconds 2000
cls
$exit = "n"
$Wortliste = ""
while($exit -ne "y" -and $exit -ne "j"){
cls
$freie_de_domains = ""
$Step1 = 1
$Wortliste = read-host "Geben Sie den Pfad zu einer Wort Liste ein"
if($Wortliste.Length -ne 0){
$domain  = read-host "Welche Domain Endung soll gescannt werden?" 
$wörter = Get-Content -Path $Wortliste  -ErrorAction SilentlyContinue

foreach($wort in $wörter){
    Write-Host "Step ",$Step1," von ",$wörter.Length
    Write-host "Prüfe: "($wort+$domain)
    $timer = 0
    $ScriptBlock = {
    Import-Module "\URLStatusCode.psm1"
    Get-UrlStatusCode ($args[0]+$domain)  -ErrorAction SilentlyContinue
    }
    $global:job_Domain_scan = Start-Job -Name "Domain Scan" -ScriptBlock $ScriptBlock -ArgumentList $wort -ErrorAction SilentlyContinue
    Do{[System.Windows.Forms.Application]::DoEvents()
         #Write-Host "Step ",$Step1," von ",$wörter.Length "`n" "Prüfe: "($wort+'.de ')$timer
        Start-Sleep  -Milliseconds 1
        $timer += 1
         #Write-Host "Step ",$Step1," von ",$wörter.Length "`n" "Prüfe: "($wort+'.de ')$timer
        if($timer -gt 200){
             Write-host "Scann nach "($wort+$domain)" abgebrochen."
            Stop-Job -Name "Domain Scan"  -ErrorAction SilentlyContinue
        }

    }Until($global:job_Domain_scan.State -eq "Completed" -or $global:job_Domain_scan.State -eq "Stopped" -or $global:job_Domain_scan.State -eq "Failed")
    Write-host $Wort "Scann " $global:job_Domain_scan.State -ErrorAction SilentlyContinue
    $statusCode = Receive-Job -Name "Domain Scan"  -ErrorAction SilentlyContinue
    Remove-Job -Name 'Domain Scan'  -ErrorAction SilentlyContinue
    Write-Host "                                                  "$statusCode, " ", ($wort+$domain)
    if($statusCode -eq 0){
        $freie_de_domains += ($wort+$domain+ "`n" )
    }
    $Step1 += 1
}

}
if($freie_de_domains.Length -ne 0){
Write-Host "Scan abgeschlossen. Folgende Domains sind nicht erreichbar:";$freie_de_domains
}
else{
cls
}
$exit = Read-Host "Beenden? (y oder j für ja, n für nein)"
}
cls
write-host "Icon von https://www.freepik.com"
start-sleep -Milliseconds 2000
cls