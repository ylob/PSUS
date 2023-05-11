<#
This PS script is used to acces MS Teams group chat to extract the conversations.
This script uses REST api to acces MS Graph which stores all the necessary data including chats for extraction.
This script also uses ChilkaDotNet library which is capable of converting the data into readable text.
Conversations are then saved locally into HTML file.
#>

$Date = Get-Date -Format "MM-dd-yyyy-HHmm"
$obj = @()
$team = $NULL
$clientId = "x"
$tenantName = "x"
$clientSecret = 'x'
$Username = "xy@zy.cz"
$Password = "123"
$pocitadlo = 1
Add-Type -Path "C:\Teams\ChilkatDotNet48.dll"
$h2t = New-Object Chilkat.HtmlToText
 
$ReqTokenBody = @{    #main tokeny k loginu
    Grant_Type    = "Password"
    client_Id     = $clientID
    Client_Secret = $clientSecret
    Username      = $Username
    Password      = $Password
    Scope         = "https://graph.microsoft.com/.default"
}
$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody
 
###TEAMS + GROUPS###
$apiUrl = "https://graph.microsoft.com/beta/groups?top=700"
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $apiUrl -Method Get
$Groups = ($Data | Select-Object Value).Value

if ($Team -eq $NULL){
    Write-Host "You have" -NoNewline
    Write-Host " $($Groups.Count)" -ForegroundColor Yellow -NoNewline
    Write-Host " teams."
    $Groups | FT DisplayName,Description
    $x = Read-Host "Napis nazev teamu pro zalohu"
    $team = $groups | Where-Object {$_.Displayname -like "*$x*"}
    $Team
    $teamID=$team.id
###TEAMS + GROUPS###

###CHANNELS###
    $apiUrl = "https://graph.microsoft.com/v1.0/teams/$TeamID/Channels"
    $Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $apiUrl -Method Get
    $Channels = ($Data | Select-Object Value).Value
    $Channels | FT DisplayName,Description
    $y = Read-Host "Napis nazev channelu pro zalohu"
    $Channel1 = $Channels | Where-Object {$_.Displayname -like "*$y*"}
    $ChannelID= $channel1[0].id
    $apiUrlMess= "https://graph.microsoft.com/beta/teams/$TeamID/channels/$ChannelID/messages?top=100"
    $dataMess = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $apiUrlMess -Method Get
    $Messages = ($DataMess | Select-Object Value).Value
###CHANNELS###

###MESSAGES###
    foreach($zprava in $messages){
        $h = "" | Select-Object Date,Author,Message,Reply,Attachments       #create-object+props
        $messageID = $zprava.id
        $apiUrl= "https://graph.microsoft.com/beta/teams/$TeamID/channels/$ChannelID/messages/$messageID/replies"
        $data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $apiUrl -Method Get
        $replies = ($Data | Select-Object Value).Value
        [array]::Reverse($replies)
        $h.Message = $h2t.ToText($zprava.body.content)
        $messtemp = $h.Message
        $h.Attachments = $h2t.ToText($zprava.attachments.contentUrl)
        $h.Date = Get-Date -Date ($zprava.createdDateTime) -Format 'dd/MM/yyyy HH:mm'     
        $h.Author = $zprava.from.user.displayName
        $h.Reply = "##MESSAGE_STRING | " + $pocitadlo + " ##"
        $obj += $h
        foreach($reply in $replies){        #REPLIES
            $h = "" | Select-Object Date,Author,Message,Reply,Attachments
            $h.Message= $messtemp
            $h.Attachments = $h2t.ToText($reply.attachments.contentUrl)
            $h.Date = Get-Date -Date ($reply.createdDateTime) -Format 'dd/MM/yyyy HH:mm'     
            $h.Author = $reply.from.user.displayName
            $h.Reply = $h2t.ToText($reply.body.content )
            if($reply.deletedDateTime -ne $NULL){
                $h.reply = "_-!-_Reply was deleted_-!-_"
            }
            $obj += $h
        }
    $pocitadlo = $pocitadlo + 1
    write-host -------------------------------
    }
###MESSAGES###

###HTML_ELEMENT###
    $Header = @"
<style>
h1, h5, th { text-align: center; } 
table { margin: auto; font-family: Segoe UI; box-shadow: 10px 10px 5px #888; border: thin ridge grey; } 
th { background: #0046c3; color: #fff; max-width: 400px; padding: 5px 10px; } 
td { font-size: 11px; padding: 5px 20px; color: #000; } 
tr { background: #b8d1f3; } 
tr:nth-child(even) { background: #dae5f4; } 
tr:nth-child(odd) { background: #b8d1f3; }
</style>

"@
 
$body = "<body><b>Generated:</b> $($date) 
 
 <b>Team Name:</b> $($Team.displayName) 
 <b>Channel Name:</b> $($Channel1.displayName) 
 
"
$body = $body + "</head>"
$obj | select-object Date,Author,Message,Reply,Attachments | export-csv -Path c:\teams\test.csv -Encoding UTF32 -Delimiter ";" 
$messhtml = $obj | ConvertTo-Html -Body $body -Head $Header 
$messhtml | Out-File c:\teams\test.html
###HTML_ELEMENT###
}
