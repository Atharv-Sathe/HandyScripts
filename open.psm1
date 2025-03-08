function op {
    param(
        [string]$fileName = $args[0],
        [string]$flag = $args[1]
    )

    $filePaths = @{
        "dsreg" = "C:\Users\athar\OneDrive\Desktop\CompSci\DSARegistry"
        "vit" = "C:\Users\athar\OneDrive\Desktop\VITB CSE"
        "vitcu" = "C:\Users\athar\OneDrive\Desktop\VITB CSE\Carriculum"
        "vitco" = "C:\Users\athar\OneDrive\Desktop\VITB CSE\COURSES"
        "cs" = "C:\Users\athar\OneDrive\Desktop\CompSci"
        "proj" = "C:\Users\athar\OneDrive\Desktop\CompSci\Projects"
        "d" = "C:\Users\athar\OneDrive\Desktop"
        "vklv" = "C:\Users\athar\OneDrive\Desktop\VisaKwik\LeleVisa"
    }


    if ($fileName -eq "list") {
      foreach($key in $filePaths.Keys) {
        Write-Host "$key : $($filePaths.$key)"
      }
      return
    }

    if ($filePaths.ContainsKey($fileName)) {
        if ($flag -eq "vs") {
            code $filePaths[$fileName]
        } elseif ($flag -eq "ex") {
            Start-Process $filePaths[$fileName]
        } elseif (-not $flag) {
            cd $filePaths[$fileName]
        } else {
            Write-Host "Invalid flag" -ForegroundColor DarkRed
            Write-Host "Usage: open.ps1 <fileName> [-vs]" -ForegroundColor Cyan
        }
    } else {
        Write-Host "File not found" -ForegroundColor DarkRed
    }
}

