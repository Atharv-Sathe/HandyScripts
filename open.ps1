$fileName = $args[0]
$flag = $args[1]

$filePaths = @{
    #"[TriggerWord1]" : "[FilePath1]"
    #"[TriggerWord2]" : "[FilePath2]"
    #"[TriggerWord3]" : "[FilePath3]"
}

if ($filePaths.ContainsKey($fileName)) {
    if ($flag -eq "vs") {
        & code $filePaths[$fileName]
        Stop-Process -Id $pid
    }
    elseif ($null -eq $flag) {
        Invoke-Item $filePaths[$fileName]
        Stop-Process -Id $pid
    }
    else {
        Write-Host "Invalid flag" -ForegroundColor DarkRed
        Write-Host "Usage: open.ps1 -fileName [-vs]" -ForegroundColor Cyan
    }
    
}
else {
    Write-Host "File not found" -ForegroundColor DarkRed
}
