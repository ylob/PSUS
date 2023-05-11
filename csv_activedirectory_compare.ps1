#This PS script compares list of computers from CSV with Active Directory (for cleanup). 
#CSV list was generated via Lansweeper where the Last Succcesful Scan property is used for comparison

##VAR##
$olderThan = "360" #(dní) #lze upravit
$finalLIST = @()
$workDir = "C:\script\csv-ad_oldPC"
$csvPath = "$workDir\web40repNotseen90days.csv"
$csvData = Import-Csv -Delimiter ";" -Path $csvPath -Encoding Default
$ADData = get-adcomputer -filter *
$maxDate = (get-date).AddDays(-$olderThan)
##VAR##

##FUNCTIONS##
foreach($csvPC in $csvData){
    $csvPCDate = (get-date $csvPC.'Last successful scan')
    if ($csvPCDate -lt $maxDate){
        $finalLIST += $csvPC
        }
    }
$finalTrimmedLIST = $FinalLIST | select AssetName, "Last successful scan", Username
$finalTrimmedLIST
##FUNCTIONS##

#$finalLIST - seznam PC starsich nez $olderthan ktere jsou v AD (all parameters)
#$finalTrimmedLIST - seznam PC starsich nez $ ktere jsou v AD (nazev+datum)
