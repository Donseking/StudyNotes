$path = "D:\DSKCODE\STUDYNOTES"
Write-Host "?? ???? $path ????..."

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $path
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    Write-Host "?? ???????,?? Git ????..."
    Start-Process "D:\DSKCODE\STUDYNOTES\wf.bat"
}

while ($true) { Start-Sleep 5 }
