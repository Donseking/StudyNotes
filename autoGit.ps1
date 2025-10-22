$path = "D:\DSKCODE\STUDYNOTES"
Write-Host "🚀 開始監控 $path 內的變更..."

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $path
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    Write-Host "🔧 檔案變更偵測到，執行 Git 自動提交..."
    Start-Process "D:\DSKCODE\STUDYNOTES\workflow.bat"
}

while ($true) { Start-Sleep 5 }
