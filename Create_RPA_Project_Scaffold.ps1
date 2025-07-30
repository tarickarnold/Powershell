function Set-Scaffold {
    param(
        [string]$folderPath,
        [string]$projectName
    )

    # Set project path
    $projectPath = Join-Path -Path $folderPath -ChildPath $projectName

    # Check if project folder exists
    if ((Test-Path $projectpath) -and ((Get-Item $projectpath).PSIsContainer)) {
        Write-Output "Folder exists"
    }
    else {
        Write-Output "Not a folder or doesn't exist"
        # Create the project folder
        New-Item -Path $projectPath -ItemType Directory -Force | Out-Null
        Write-Output "Project folder created."
    }

    # Create Config, Screenshots, and Logs folder
    $folders = @("Config", "Screenshots", "Logs", "Data")
    foreach ($folder in $folders) {
        $folderPath = Join-Path -Path $projectPath -ChildPath $folder
        New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
    }

    # Define variable names and their corresponding paths
    $configPath = Join-Path -Path $projectPath -ChildPath "Config"
    $screenshotFolderPath = Join-Path -Path $projectPath -ChildPath "Screenshots"
    $businessEmail = ""

    if ($folderPath.Contains("Dev")) {
        # Dev Email
        $opsEmail = ""
    }
    else {
        # Prod Email
        $opsEmail = ""
    }

    # Create hashtable for CSV data
    $configData = @(
        @{ VariableName = 'vScreenshotFolderPath'; Value = $screenshotFolderPath }
        @{ VariableName = 'vOpsEmail'; Value = $opsEmail }
        @{ VariableName = 'vBusinessEmail'; Value = $businessEmail }
    )

    # Export to config.csv
    $configCsvPath = Join-Path -Path $configPath -ChildPath "config.csv"
    $configData | Export-Csv -Path $configCsvPath -NoTypeInformation

    Write-Host "Project structure created at: $devprojectPath"
    Write-Host "Config file saved to: $configCsvPath"
}

#-----------------------------SCRIPT---------------------------------------------------
# Prompt user for project name
$projectName = Read-Host "Enter the project name"
$businessUnit = Read-Host "Enter the business unit name"

# Set file bot project path
$devPath = ""
$prodPath = ""

# Set path to business unit
$devBusinessUnitPath = Join-Path -Path $devPath -ChildPath $businessUnit
$prodBusinessUnitPath = Join-Path -Path $prodPath -ChildPath $businessUnit


# Define list for function
$pathList = @($devBusinessUnitPath, $prodBusinessUnitPath)

# Loop through and call the function
foreach ($path in $pathList) {
    Set-Scaffold -folderPath $path -projectName $projectName
}
