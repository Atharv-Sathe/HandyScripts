param (
    [string[]]$files
)

$jobs = @()

foreach ($file in $files) {
    $job = Start-Job -ScriptBlock {
        param($file)

        $outputDir = "CompiledExecs"

        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir
        }

        $isCompiled = $true;

        function CompileClike($file, $compiler) {
            $exeName = [System.IO.Path]::GetFileNameWithoutExtension($file)
            $exePath = Join-Path $outputDir "$exeName.exe"
            & $compiler $file -o $exePath
            if (Test-Path $exePath) {
                return $true
            }
            else {
                return $false
            }
        }

        if (-not (Test-Path $file)) {
            Write-Host "File $file does not exist" -ForegroundColor DarkRed
            return
        }

        $extension = [System.IO.Path]::GetExtension($file)

        Write-Host "Compiling $file 🚀" -ForegroundColor DarkYellow 
        
        try {
            switch ($extension) {
                '.cpp' { 
                    $isCompiled = CompileClike $file 'g++' 
                }
                '.c' { 
                    $isCompiled = CompileClike $file 'gcc' 
                }
                '.java' {
                    $className = [System.IO.Path]::GetFileNameWithoutExtension($file)
                    javac $file
                    if (Test-Path "$className.class") {
                        Rename-Item "$className.class" "$outputDir/$className.class"
                    }
                    else {
                        $isCompiled = $false
                    }
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
        
        if ($isCompiled -eq $true) {
            Write-Host "Compilation Successful for $file ✅" -ForegroundColor Green
        }
        else {
            Write-Host "Compilation Failed for $file ❌" -ForegroundColor DarkRed
        }

    } -ArgumentList $file

    $jobs += $job
}

# Wait for all jobs to complete
$jobs | Wait-Job

# Display output and remove jobs
foreach ($job in $jobs) {
    Receive-Job $job
    Remove-Job $job
}

# Execution Stage
foreach ($file in $files) {
    $extension = [System.IO.Path]::GetExtension($file)
    $exeName = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $outputDir = "CompiledExecs"
    $exePath = Join-Path $outputDir "$exeName.exe"
    $classPath = Join-Path $outputDir "$exeName.class"
    
    if (-not (Test-Path $exePath) -and -not (Test-Path $classPath)) {
        continue
    }

    Write-Host "Executing $file 🚀" -ForegroundColor DarkYellow
    try {
        switch ($extension) {
            '.cpp' {
                if (Test-Path $exePath) {
                    $startTime = Get-Date
                    & $exePath | Out-Host
                    $endTime = Get-Date
                    $runtime = $endTime - $startTime
                    Write-Host "Execution Time: $($runtime.TotalSeconds) seconds" -ForegroundColor DarkBlue
                    Remove-Item $exePath
                }
            
            } 
            '.c' { 
                if (Test-Path $exePath) {
                    $startTime = Get-Date
                    & $exePath | Out-Host
                    $endTime = Get-Date
                    $runtime = $endTime - $startTime
                    Write-Host "Execution Time: $($runtime.TotalSeconds) seconds" -ForegroundColor DarkBlue
                    Remove-Item $exePath
                }
            }
            '.java' {
                if (Test-Path $classPath) {
                    $startTime = Get-Date
                    java -cp $outputDir $exeName | Out-Host
                    $endTime = Get-Date
                    $runtime = $endTime - $startTime
                    Write-Host "Execution Time: $($runtime.TotalSeconds) seconds" -ForegroundColor DarkBlue
                    Remove-Item $classPath
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
        Write-Host "Execution Successful for $file ✅" -ForegroundColor Green
    }
    else {
        Write-Host "Possible Runtime Error for $file ⭕" -ForegroundColor DarkRed
    }
    
}