$repo = "D:\DSKCODE\STUDYNOTES"
$cooldownSeconds = 10
$lastRun = Get-Date "2000-01-01"

$Host.UI.RawUI.WindowTitle = "AutoGitWatcher"

Write-Host "AutoGit 系統啟動中..."
Write-Host "監控路徑：$repo"
Write-Host "冷卻間隔：$cooldownSeconds 秒"
Write-Host "------------------------------------------"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repo
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    $changedFile = $Event.SourceEventArgs.FullPath

    # 排除 .git 與自動工具檔案
    if ($changedFile -match "\\.git\\") { return }
    $excludeFiles = @("autogit.ps1","workflow.bat")
    foreach ($f in $excludeFiles) {
        if ($changedFile -like "*$f") { return }
    }

    # 檢查副檔名
    $allowedExt = @(".md", ".txt", ".py")
    if ($allowedExt -notcontains [System.IO.Path]::GetExtension($changedFile)) { return }

    # 冷卻
    $now = Get-Date
    if (($now - $lastRun).TotalSeconds -lt $cooldownSeconds) { return }
    $global:lastRun = $now

    Write-Host "`n 偵測到變更：$changedFile"
    Write-Host " 執行自動推送流程..."

    # Git 操作
    cd $repo
    git status
    Write-Host " git add ."
    git add .
    $timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    Write-Host " git commit -m 'Auto Commit - $timestamp'"
    git commit -m "Auto Commit - $timestamp" 2>$null
    Write-Host " git push origin main 2>$null"
    git push origin main 2>$null

    Write-Host " 推送完成！ [$timestamp]"
}

while ($true) { Start-Sleep 5 }
