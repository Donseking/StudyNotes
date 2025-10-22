$repo = "D:\DSKCODE\STUDYNOTES"
$cooldownSeconds = 10
$lastRun = Get-Date "2000-01-01"

$Host.UI.RawUI.WindowTitle = "AutoGitWatcher"

Write-Host "?? AutoGit ?????..."
Write-Host "?? ????:$repo"
Write-Host "?? ????:$cooldownSeconds ?"
Write-Host "------------------------------------------"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repo
$watcher.Filter = "*.md"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    $changedFile = $Event.SourceEventArgs.FullPath
    if ($changedFile -match "\\.git\\") { return }

    $now = Get-Date
    if (($now - $lastRun).TotalSeconds -lt $cooldownSeconds) { return }
    $global:lastRun = $now

    Write-Host "`n?? ?????:$changedFile"
    Write-Host "?? ????????..."

    # Git ??
    cd $repo
    git add .
    $timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    git commit -m "Auto Commit - $timestamp" 2>$null
    git push origin main 2>$null

    Write-Host "? ????! [$timestamp]"
}

while ($true) { Start-Sleep 5 }
