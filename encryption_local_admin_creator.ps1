#This PS script creates an local user with password that is created by user and deletes the current user from Administrators group
#e.g. user Tomas is using domain account which has admin rights. After running this script, user Tomas-local will be created and added to Administrators group aswell as his domain account will be deleted from there.

Write-host "Script pro vytvoreni admin. uctu a smazani stavajiciho"
$creds = Get-Credential -Credential "$env:USERNAME-loc"
$passwordCheck = Read-Host -AsSecureString "Pro kontrolu zadejte znovu HESLO."

#checkpw
$pwcred=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($creds.Password))
$pwcheck=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordCheck))
$name = $creds.UserName
if($pwcred -like $pwcheck){
    try{New-LocalUser -Name $creds.UserName -Password $creds.Password -ErrorAction Stop
        Add-LocalGroupMember -Group Administrators -Member $creds.UserName
        New-Item -Path $env:USERPROFILE\loginlocal.txt -ItemType File -Value "$name|$pwcred"
        net localgroup administrators $env:USERNAME /delete
        write "Nove prihlasovaci udaje k admin. uctu se nachazeji na $env:USERPROFILE\loginlocal.txt"}
    catch{write-host "Ucet nebyl vytvoren. Zkuste to prosim znova. Heslo musi mit minimalne 8 znaku, 1 cislici a 1 velky pismeno."}
}
else
{
    write "HESLA SE NESHODUJÍ, ZKUSTE TO PROSÍM ZNOVA"
}
