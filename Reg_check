<#
This PS script checks the value of registry from remote computer using PSEXEC utility. 
#>

$PCs = @("nb1", "nb2", "pc1", "pc2") #list of PCs
$REGSubKey = "IgnoreOpenReadonlyHandlesOnAutoLogout" #reg name
$OffPCs = @()
$PCInfo = @()
foreach ($PC in $PCs){
    $testOnline = Test-Connection -ComputerName $PC -Count 1
    if ($testOnline){
        $PCInfoTemp = "" | select User, Online, RegistryValue
        
        $PCInfoTemp.Online = $PC

        $RegInfoTemp = C:\tools\psexec\PsExec.exe -s \\$pc powershell.exe Get-ItemProperty -Path HKLM:\SOFTWARE\Motive\M-Files\22.1.11017.5\Client\MFClient -name IgnoreOpenReadonlyHandlesOnAutoLogout
        $PCInfoTemp.User = (Get-ChildItem -path "\\$pc\c$\users" | Sort-Object LastWriteTime -Descending)[0].Name

        $PCInfoTemp.RegistryValue = $RegInfoTemp | Select-String -Pattern $REGSubKey

        $PCInfo += $PCInfoTemp
        write-host $PC
    }
    else{
    $OffPCs += $PC
    }
}
