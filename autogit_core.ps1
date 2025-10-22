# -------------------------------
# AutoGit 模組化工作流監控系統 (含桌面通知)
# -------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$repo = "D:\DSKCODE\STUDYNOTES"
$cooldownSeconds = 10
$lastRun = Get-Date "2000-01-01"

$Host.UI.RawUI.WindowTitle = "AutoGitWatcher"

Write-Host "AutoGit 系統啟動中..."
Write-Host "監控路徑：$repo"
Write-Host "冷卻間隔：$cooldownSeconds 秒"
Write-Host "------------------------------------------"

# --- 設定監控檔案副檔名 ---
$allowedExt = @(".md", ".txt", ".py")  

# --- 排除的檔案或資料夾 ---
$excludeFiles = @("autogit.bat", "autogit_core.ps1")  
$excludeFolders = @(".git")                      

# -------------------------------
# 桌面通知函數
# -------------------------------
function ShowNotification($title, $message) {
    $notification = New-Object System.Windows.Forms.NotifyIcon
    $notification.Icon = [System.Drawing.SystemIcons]::Information
    $notification.Visible = $true
    $notification.BalloonTipTitle = $title
    $notification.BalloonTipText = $message
    $notification.ShowBalloonTip(3000)  # 顯示 3 秒
    Start-Sleep 3
    $notification.Dispose()
}

# -------------------------------
# 工作流函數
# -------------------------------
function GitWorkflow($file) {
    cd $repo
    Write-Host " [Git] git add ."
    git add .
    $timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    Write-Host " [Git] git commit -m 'Auto Commit - $timestamp'"
    git commit -m "Auto Commit - $timestamp" 2>$null
    Write-Host " [Git] git push origin main $null"
    git push $null
    Write-Host " [Git] 推送完成！ [$timestamp]"
}

function BackupWorkflow($file) {
    $backupPath = "D:\Backup"
    if (-not (Test-Path $backupPath)) { New-Item -ItemType Directory -Path $backupPath | Out-Null }
    Copy-Item $file -Destination $backupPath -Force
    Write-Host " [Backup] 備份完成：$file -> $backupPath"
}

function FormatWorkflow($file) {
    if ($file -like "*.py") {
        Write-Host " [Format] 格式化 Python: $file"
        black $file 2>$null
    }
}

function PdfWorkflow($file) {
    if ($file -like "*.md") {
        $pdfFile = "$($file -replace '\.md$', '.pdf')"
        Write-Host " [PDF] 生成 PDF: $pdfFile"
        pandoc $file -o $pdfFile 2>$null
    }
}

function RunWorkflows($file) {
    GitWorkflow $file
    # BackupWorkflow $file
    # FormatWorkflow $file
    # PdfWorkflow $file
    ShowNotification "AutoGit 工作流完成" "檔案已處理: $(Split-Path $file -Leaf)"
}

# -------------------------------
# 設定檔案監控
# -------------------------------
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repo
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    $changedFile = $Event.SourceEventArgs.FullPath

    # 排除資料夾
    foreach ($folder in $excludeFolders) {
        if ($changedFile -like "*\$folder\*") { return }
    }

    # 排除檔案
    foreach ($f in $excludeFiles) {
        if ($changedFile -like "*$f") { return }
    }

    # 副檔名篩選
    if ($allowedExt -notcontains [System.IO.Path]::GetExtension($changedFile)) { return }

    # 冷卻機制
    $now = Get-Date
    if (($now - $lastRun).TotalSeconds -lt $cooldownSeconds) { return }
    $global:lastRun = $now

    Write-Host "`n偵測到變更：$changedFile"
    Write-Host " 執行工作流..."
    RunWorkflows $changedFile
}

# -------------------------------
# 持續運行
# -------------------------------
while ($true) { Start-Sleep 5 }
