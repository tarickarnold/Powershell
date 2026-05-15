function Write-JsonLog {
    param(
        [string]$LogFile,
        [string]$Level,
        [string]$ScriptName,
        [string]$ExecutionId,
        [string]$Message,
        [string]$File = "",
        [int]$Line = 0,
        [string]$Exception = ""
    )

    $logDir = Split-Path $LogFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    $entry = [ordered]@{
        timestamp    = (Get-Date).ToUniversalTime().ToString("o")
        level        = $Level
        script       = $ScriptName
        hostname     = $env:COMPUTERNAME
        execution_id = $ExecutionId
        message      = $Message
        file         = $File
        line         = $Line
        exception    = $Exception
    }

    ($entry | ConvertTo-Json -Compress) | Add-Content -Path $LogFile -Encoding UTF8
}

$logFile = "C:\Logs\MyBot\powershell_script.log"
$scriptName = "powershell_script"
$executionId = [guid]::NewGuid().ToString()

Write-JsonLog -LogFile $logFile -Level "INFO" -ScriptName $scriptName -ExecutionId $executionId -Message "Script started"

try {
    throw "Something failed"
}
catch {
    Write-JsonLog `
        -LogFile $logFile `
        -Level "ERROR" `
        -ScriptName $scriptName `
        -ExecutionId $executionId `
        -Message "Script failed" `
        -Exception $_.Exception.Message
}

Write-JsonLog -LogFile $logFile -Level "INFO" -ScriptName $scriptName -ExecutionId $executionId -Message "Script finished"
