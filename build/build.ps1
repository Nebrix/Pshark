param (
    [string]$userInput
)

$projectName = "Pshark"
$windowspythonScript = "windows\main.py"
$linuxpythonScript = "linux/main.py"
$outputFolder = "dist"
$buildCommand = "pyinstaller"

function Remove-BuildFolder {
    if (Test-Path -PathType Container $outputFolder) {
        Write-Host "Removing build folder: $outputFolder"
        Remove-Item -Path $outputFolder -Force -Recurse
    }
}

if (-not (Test-Path -PathType Container $outputFolder)) {
    New-Item -ItemType Directory -Force -Path $outputFolder
}

$requiredPackages = "pyinstaller", "scapy", "psutil"
$installedPackages = Get-Content "requirements.txt" | ForEach-Object { $_.Trim() }
$missingPackages = $requiredPackages | Where-Object { $_ -notin $installedPackages }

if ($missingPackages.Count -gt 0) {
    Write-Host "Installing missing packages: $($missingPackages -join ', ')"
    $missingPackages | ForEach-Object {
        Add-Content -Path "requirements.txt" -Value $_
        pip install $_
    }
}

if ($userInput -eq "windows" -or $userInput -eq "linux") {
    Write-Host "Building $projectName for $userInput..."

    $pythonScript = if ($userInput -eq "windows") { $windowspythonScript } else { $linuxpythonScript }
    $buildCmd = "$buildCommand $pythonScript --onefile --name $projectName --distpath $outputFolder --clean"

    Invoke-Expression -Command $buildCmd
}
elseif ($userInput -eq "clean") {
    $itemsToRemove = @(".\dist", ".\build\Pshark", "Pshark.spec")
    
    foreach ($item in $itemsToRemove) {
        Remove-Item $item -Force -Recurse
    }
}
else {
    Write-Host "Invalid target platform specified. Use 'windows' or 'linux'."
    Exit 1
}

Write-Host "Build completed for $userInput. Executable is located in: $outputFolder"
Exit 0
