$csvFileName = "%ProjectName%" + "_" + (Get-Date -Format "yyyyMMdd") + ".csv"
$csvPath = "%ProjectFilePath%\%ProjectName%\Bot Metrics\$csvFileName.csv"
$columnNames = "BotName", "MachineName", "BotUserName", "BusinessUnit", "JobID", "RunDate", "StartTime", "EndTime", "TotalTransactions", "SuccessCount", "HumanTime", "BusinessException", "SystemException"
$csvContent = $columnNames -join ','
$csvContent | Out-File -FilePath $csvPath -Encoding ascii
