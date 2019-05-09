$date = Get-Date -Format yyyy-MM-dd
$delteFiles = 0

try{
    #Copy Files to own image path
    "Kopiere Bilder zu den eigenen Bildern ..."
    copy-item -path D:\Bilder\DCIM -filter *.PNG -destination C:\Users\mario\Pictures\neueBilder\$date -recurse -Force
    #copy files to usb device
    "Kopiere Bilder auf den USB Stick ..."
    #copy-item -path D:\Bilder -filter *.PNG -destination C:\Users\mario\Pictures\neueBilder\$date -recurse

    $delteFiles = 1;
}catch{"Fehler beim Kopieren der Bilder"}

"`n--- Kopieren der Bilder fertig ---`n"
ii C:\Users\mario\Pictures\neueBilder

"Loesche Bilder jetzt von SD-Karte ..."
try{
    if($delteFiles -eq 1){
        remove-item -path D:\Bilder\DCIM -recurse
        exit
    }
}catch{
    $ErrorMessage = $_.Exception.Message
    Write-Error $ErrorMessage
    "Fehler beim Loeschen der Bilder von der SD-Karte"}

