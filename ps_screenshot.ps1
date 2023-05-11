#Simple PS script to take screenshot using .net library

$prntsc = {
add-type -assemblyname "System.Windows.Forms" #nacteni knihovny potrebne pro screenshot
$time = get-date -Format "dd.MM_hh-mm" #datum+cas pro jmeno porizeneho screenshotu
$path = "c:\users\public\ps\zat\" #misto scriptu+screenu
if((Test-Path -Path $path)-ne $true){New-Item -Path $path -Force} #pokud adresar neexistuje, vytvori se
[System.Windows.Forms.SendKeys]::SendWait("{PRTSC}")
sleep 3
$screenshot = Get-Clipboard -Format Image
$screenshot.save("$path\$time.jpg")
}
$encoded = [System.Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($prntsc))
