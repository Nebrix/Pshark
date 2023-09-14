param (
    [string]$userInput
)

$projectName = "Pshark"
$windowspythonScript = "windows\main.py"
$linuxpythonScript = "linux/main.py"
$outputFolder = ".\dist"
$buildCommand = "pyinstaller"

function Remove-BuildFolder {
    if (Test-Path -PathType Container $outputFolder) {
        Write-Host "Removing build folder: $outputFolder"
        Remove-Item -Path $outputFolder -Force -Recurse
    }
}

# Determine the correct path separator based on the platform
if ($env:OS -eq "Windows_NT") {
    $pathSeparator = "\"
} else {
    $pathSeparator = "/"
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

    # Use the platform-specific command to invoke the build
    if ($env:OS -eq "Windows_NT") {
        Invoke-Expression -Command $buildCmd
    } else {
        # Use the bash shell to run the command on Linux
        bash -c $buildCmd
    }
}
elseif ($userInput -eq "clean") {
    $itemsToRemove = @($outputFolder, ".\build\Pshark", "Pshark.spec")
    
    foreach ($item in $itemsToRemove) {
        # Use the platform-specific command to remove items
        if ($env:OS -eq "Windows_NT") {
            Remove-Item $item -Force -Recurse
        } else {
            rm -rf $item
        }
    }
}
else {
    Write-Host "Invalid target platform specified. Use 'windows' or 'linux'."
    Exit 1
}

Write-Host "Build completed for $userInput. Executable is located in: $outputFolder"
Exit 0
