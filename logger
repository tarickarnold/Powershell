# Set your log file path (change as needed)
$Global:LogFilePath = "C:<project_path_here>\Logs\<progject_name_here>.log.jsonl"

function Write-LogJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('DEBUG','INFO','WARN','ERROR','FATAL')]
        [string]$Level,

        [Parameter(Mandatory)]
        [string]$Message,

        # Optional: structured data to include (hash table or object)
        [Parameter()]
        [object]$Data,

        # Optional: pass an Exception or ErrorRecord
        [Parameter()]
        [object]$ErrorObject,

        # Optional: override the log file path
        [Parameter()]
        [string]$LogFilePath = $Global:LogFilePath
    )

    if (-not $LogFilePath) {
        throw "Log file path is not set. Set `$Global:LogFilePath or pass -LogFilePath."
    }

    # Ensure log directory exists
    $logDir = Split-Path -Path $LogFilePath -Parent
    if ($logDir -and -not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    }

    # Normalize error info (if provided)
    $exceptionMessage = $null
    $exceptionType    = $null
    $stackTrace       = $null

    if ($ErrorObject) {
        if ($ErrorObject -is [System.Management.Automation.ErrorRecord]) {
            $exceptionMessage = $ErrorObject.Exception.Message
            $exceptionType    = $ErrorObject.Exception.GetType().FullName
            $stackTrace       = $ErrorObject.ScriptStackTrace
        }
        elseif ($ErrorObject -is [System.Exception]) {
            $exceptionMessage = $ErrorObject.Message
            $exceptionType    = $ErrorObject.GetType().FullName
            $stackTrace       = $ErrorObject.StackTrace
        }
        else {
            $exceptionMessage = [string]$ErrorObject
        }
    }

    # Build log entry as a PSCustomObject
    $logEntry = [PSCustomObject]@{
        timestamp = (Get-Date).ToUniversalTime().ToString("o")  # ISO 8601 in UTC
        level     = $Level
        message   = $Message
    }

    if ($Data) {
        # Keep structured data as-is; ConvertTo-Json will handle nesting
        $logEntry | Add-Member -NotePropertyName 'data' -NotePropertyValue $Data
    }

    if ($exceptionMessage) {
        $errorInfo = [PSCustomObject]@{
            message = $exceptionMessage
        }
        if ($exceptionType)  { $errorInfo | Add-Member type       $exceptionType }
        if ($stackTrace)     { $errorInfo | Add-Member stackTrace $stackTrace }

        $logEntry | Add-Member -NotePropertyName 'exception' -NotePropertyValue $errorInfo
    }

    # Convert to compact single-line JSON
    $json = $logEntry | ConvertTo-Json -Depth 10 -Compress

    # Append to file
    Add-Content -Path $LogFilePath -Value $json
}
