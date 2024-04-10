param (
    [string[]]$files
)

$outputDir = "CompiledExecs"

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

$isCompiled = $true;

function CompileAndRunClike($file, $compiler) {
    $exeName = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $exePath = Join-Path $outputDir "$exeName.exe"
    & $compiler $file -o $exePath
    if (Test-Path $exePath) {
        # $runtime = Measure-Command { & $exePath | Out-Host } // This also includes the time taken to run the "Measure-Command" command
        $startTime = Get-Date
        & $exePath | Out-Host
        $endTime = Get-Date
        $runtime = $endTime - $startTime
        Write-Host "Execution Time: $($runtime.TotalSeconds) seconds" -ForegroundColor DarkBlue
        Remove-Item $exePath
        return $true
    }
    else {
        Write-Host "Failed to compile $file" -ForegroundColor DarkRed
        return $false
    }
}


foreach ($file in $files) {

    if (-not (Test-Path $file)) {
        Write-Host "File $file does not exist" -ForegroundColor DarkRed
        continue
    }

    $extension = [System.IO.Path]::GetExtension($file)

    Write-Host "Launching $file 🚀" -ForegroundColor Green 
    
    try {
        switch ($extension) {
            '.cpp' { 
                $isCompiled = CompileAndRunClike $file 'g++' 
            }
            '.c' { 
                $isCompiled = CompileAndRunClike $file 'gcc' 
            }
            '.java' {
                $className = [System.IO.Path]::GetFileNameWithoutExtension($file)
                javac $file
                if (Test-Path "$className.class") {
                    $startTime = Get-Date
                    java $className
                    $endTime = Get-Date
                    $runtime = $endTime - $startTime
                    Write-Host "Execution Time: $($runtime.TotalSeconds) seconds" -ForegroundColor DarkBlue
                    Remove-Item "$className.class"
                }
                else {
                    Write-Host "Failed to compile $file" -ForegroundColor DarkRed
                    $isCompiled = $false
                }
            }
            '.py' {
                $startTime = Get-Date
                python $file
                $endTime = Get-Date
                $runtime = $endTime - $startTime
                Write-Host "Execution Time: $($runtime.TotalSeconds) seconds" -ForegroundColor DarkBlue
            }
            Default {
                write-host "Unsupported file type: $extension" -ForegroundColor Cyan
            }
        }
    }
    catch {
        write-host "Error: $_" -ForegroundColor DarkRed
        continue
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Mission Accomplised for $file ✅" -ForegroundColor Green
    }
    elseif ($isCompiled -eq $false) {
        Write-Host "Mission Aborted for $file ❌" -ForegroundColor DarkRed
    }
    else {
        Write-Host "Possible Runtime Error for $file ⭕" -ForegroundColor DarkRed
    }
}