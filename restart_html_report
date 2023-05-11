# This is one of the early scripts i wrote. This one simply checks computers last date of restart (event log from event viewer) and compares it with desired time range.
# Results are then exported via readable HTML. This script also checks if the PCs in the list are available in AD (error catching)
 
<#Legenda :
$a = Datum uživatelského PC
$b = seznam uživatelských PC
$c = název jednotlivých PC
$d = aktuální čas
$e = kolik dni dozadu hledame restart
$g = ping test
#>

$obj = @()
$e = read-host ("Kolik dní?")
$d = (get-date)
for($p = 1001; $p -le 1005; $p++){
$b = "nbpb$p"

foreach($c in $b){

$h = "" | Select-Object OK,Restart_needed,OFFLINE

$g = Test-Connection -ComputerName $c -Quiet -Count 1 -BufferSize 1
   if($g -eq "True"){

 $a = get-winevent -FilterHashtable @{Logname='System';data='Restartování'} -ComputerName $c  -MaxEvents 1
     if($a.TimeCreated.AddDays($e) -gt $d){
         
         $h.OK = $c
         $obj+=$h
         }
     else{
         $h.Restart_needed = $c
         $obj+=$h

         }
}
else{    
         $y = (get-ADComputer -filter * -Properties LastLogonDate | Where-Object {$_.Name -like "$c"}).LastLogonDate
         if($y -like ""){
         $y = "notebook je vyřazen"}
         $h.OFFLINE = "$c -naposledy online:  $y"
         $obj+=$h

 }
}
}
############################HTML######################################
$css = @' 
<style> 
body { font-family: Arial; } 
table { 
width: 100%; 
border-collapse: collapse; 
    } 
table, th, td { 
border: 1px solid Black; 
padding: 5px; 
    } 
th { 
text-align: left; 
background-color: LightBlue; 
    } 
tr { 
$colorTagTable = @{OK = ' bgcolor="#ff0000">Stopped<';
                   OFFLINE = ' bgcolor="#00ff00">Running<'
                   Restart_needed 'bgcolor="#00ff00">Running<'}}
$colorTagTable.Keys | foreach { $body = $body -replace ">$_<",($colorTagTable.$_) }
</style> 
'@ 
 
$obj | ConvertTo-Html -head $css -PostContent $d| Out-File "\\cdc-nb\share\vypis_restart_30days.html"
