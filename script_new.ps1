#########
################## ZDE SE M�N� PO�ET STRAN
$pocet_stran = 1                 
################## ZDE SE M�N� PO�ET STRAN
#########


$names = @()

$datum = Get-Date -Format "dd.MM.yyyy HH-mm"

$source_script_folder = "$env:USERPROFILE\script_zkusebna\transfer"

$pdf_main_name = (gci $source_script_folder).Name | ?{$_ -like "*.pdf"}

write-host $pdf_main_name

$pdf_out_fold = $pdf_main_name.Replace(".pdf", "") + " $datum"

$pdf_main = Get-PDF -FilePath "$source_script_folder\$pdf_main_name"

$pages_count = (Get-PDFDetails -Document $pdf_main).pages.count

for($i = 1;$i -le $pages_count; $i += $pocet_stran)
{
    
    $page_text = Convert-PDFToText -FilePath "$source_script_folder\$pdf_main_name" -Page $i
    
    $page_text_split = $page_text -split "��slo protokolu"
    
    $page_text_split = $page_text_split -split "Datum zkou�ky"
    
    $name_untrimmed = $page_text_split[1] -replace (" ", "")
    
    $name_trimmed = $name_untrimmed.trim()

    write-host "P�id�v�m $name_trimmed do array."
    
    $names += $name_trimmed
}
$names = $names -replace("/", "_")

Write-Host "Splitov�n� hl. PDF"

Split-PDF -FilePath "$source_script_folder\$pdf_main_name" -OutputName "" -SplitCount $pocet_stran -OutputFolder $source_script_folder

$created_pdf_count = (gci $source_script_folder | ?{$_.name -notlike "$pdf_main_name" -and $_.name -notlike "Output"}).count

write-host "Po�et PDF - $created_pdf_count"

New-Item -Path "$source_script_folder\Output\" -Name $pdf_out_fold -ItemType "directory"

for($x = 0; $x -le ($created_pdf_count - 1); $x++)
{
   $single_name = $names[$x] + ".pdf"
   
   $origin_path = "$source_script_folder\$x.pdf"
   
   $destination_path = "$source_script_folder\Output\$pdf_out_fold\$single_name"
   
   Move-Item -path $origin_path -Destination $destination_path

   write-host "PDF soubor $single_name byl vytvo�en"
}

copy-Item -path "$source_script_folder\$pdf_main_name" -Destination "$source_script_folder\Output\$pdf_out_fold\$pdf_main_name" -Force

Write-Host "P�vodn� + nov� PDF ulo�eny do "$source_script_folder\Output\$pdf_out_fold""
