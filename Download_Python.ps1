# Function to get the latest Python version number from the official Python website
Function Get-LatestPythonVersion {
    param(
        [str] $downloadPath
    )
    Try {
        # Step 1: Download the page source
        $html = Invoke-WebRequest -Uri "https://www.python.org/downloads/" -UseBasicParsing

        # Step 2: Extract the .exe link for Windows using regex
        ($html.Content -match 'https:\/\/www\.python\.org\/ftp\/python\/[\d.]+\/python-[\d.]+-amd64\.exe') | Out-Null
        $downloadUrl = $Matches[0]

        # Step 3: Set output path and download the file
        Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

        Write-Output "Downloaded Python installer to $downloadPath" -ForegroundColor Green
    }

    Catch {
        Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    }

}


Function Start-PythonInstaller {
    param(
        [str] $downloadPath,
        [str] $pythonPath
    )

    # Define the Python installation options (quiet mode, add to PATH, precompile standard library)
    $pythonInstallOptions = "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0"

    Try {
        # Run the Python installer
        Write-Host "Installing Python latest python version..."
        Start-Process -FilePath $tempFolder -ArgumentList $pythonInstallOptions -Wait

        # Check if Python is installed successfully
        if ($pythonPath) {
            Write-Host "Python installed successfully at $pythonPath" -ForegroundColor Green
        }
        else {
            Write-Host "Python installation failed." -ForegroundColor Red
            exit 1
        }

        # Clean up the Python installer
        Remove-Item $downloadPath
    }

    Catch {
        Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    }
    
}

#--------------------------------SCRIPT--------------------------------------

$pythonInstallerPath = "$env:TEMP\python-installer.exe"
$pythonPath = (Get-Command python).Source

# Check if Python is installed
if (Get-Command python -ErrorAction SilentlyContinue) {
    $version = python --version
    Write-Output "Python is installed: $version" -ForegroundColor Green
}
else {
    Write-Output "Python is not installed or not in PATH." -ForegroundColor Orange
    
    # Get the latest Python version
    Get-LatestPythonVersion -downloadPath $pythonInstallerPath
    Start-PythonInstaller -downloadPath $pythonInstallerPath -pythonPath $pythonPath
}

# Add Python to PATH environment variables (if not already added)
$envPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($envPath -notlike "*$pythonPath*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$envPath;$pythonPath", "User")

    # Verify Python installation 
    Write-Host "Python path added to user environment variables." -ForegroundColor Blue
    Start-Process -FilePath "python" -ArgumentList "--version" -NoNewWindow -Wait
}
else {
    Write-Host "Python path already exists in user environment variables." -ForegroundColor Green
}
