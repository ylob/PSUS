<# 
This PS script sends an sms via GSM modem (Siemens MC39i) based on the result of ping test to server.
For correct function, a CSV with list of servers that stores names and IPs aswell as current status must be created in order to function properly.
Csv must have this properties in order : "server_name","server_ip","send_UP_message","send_DOWN_message" , encoding - UTF8 using ';' as delimiter.
#>

$csv_out = @()
$mobilNumber = "+420xxxxxxxx"


function posliSMS($message, $mobilNumber){
    $port = New-Object System.IO.Ports.SerialPort
    $port.PortName = "COM1"
    $port.BaudRate = "115200"
    $port.Parity = "None"
    $port.DataBits = 8
    $port.StopBits = 1
    $port.ReadTimeout = 3000 # 9 seconds
    $port.DtrEnable = "true"
    
     $port.open() #otevreni pripojeni s modemem
     Start-Sleep -Seconds 2
     $port.Write("AT+CMGS=$mobilnumber`r`n")
     Start-Sleep -Seconds 2
     # Zapsani sms do modemu
     $port.Write("$message`r`n")
     $port.Write($([char] 26))
     # Wait for modem to send it
     Start-Sleep -Seconds 2
    
     $port.Close() #closes serial connection
    
    }

while($true){
    $csv_import = import-csv "C:\script\sms_notification\variables.csv" -delimiter ";" -Encoding Unicode
    $csv_out = @()
    foreach ($csv_single_import in $csv_import){
    sleep 1
    $h = "" | Select-Object "server_name","server_ip","send_UP_message","send_DOWN_message"  #temp. var
        $ping_test = test-connection -ComputerName $csv_single_import.server_ip -quiet -count 1
        if($ping_test){
            write-host $csv_single_import.server_name + " is up"
            if($csv_single_import.send_UP_message -eq 1){
                $csv_single_import.send_DOWN_message = 1
                $csv_single_import.send_UP_message= 0 
                #posliSMS "$csv_single_import.server_name is UP AGAIN" $mobilNumber
                write-host "sending sms up"
            }
        }
        elseif($csv_single_import.send_DOWN_message -eq 1){
            
                write-host -ComputerName $csv_single_import.server_ip + " is down - 10 tries"
                $ping_test = Test-Connection $csv_single_import.server_ip -count 10 -Quiet
                if($ping_test -eq $false){
                    $csv_single_import.send_DOWN_message = 0
                    $csv_single_import.send_UP_message = 1 
                    posliSMS "$csv_single_import.server_name is Down AGAIN" $mobilNumber
                    write-host "sending sms down"
                }
                write-host $ping_test
        }
    $h.send_DOWN_message = $csv_single_import.send_DOWN_message
    $h.send_UP_message = $csv_single_import.send_UP_message
    $h.server_name = $csv_single_import.server_name
    $h.server_ip = $csv_single_import.server_ip
    $csv_out += $h 
    }
    $csv_out | Export-Csv -Path "C:\script\sms_notification\variables.csv" -delimiter ";" -Encoding Unicode
}
