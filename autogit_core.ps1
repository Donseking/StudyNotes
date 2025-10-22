# -------------------------------
# AutoGit 模組化工作流監控系統
# -------------------------------

$repo = "D:\DSKCODE\STUDYNOTES"
$cooldownSeconds = 10
$lastRun = Get-Date "2000-01-01"

$Host.UI.RawUI.WindowTitle = "AutoGitWatcher"

Write-Host "AutoGit 系統啟動中..."
Write-Host "監控路徑：$repo"
Write-Host "冷卻間隔：$cooldownSeconds 秒"
Write-Host "------------------------------------------"

# --- 設定監控檔案副檔名 ---
$allowedExt = @(".md", ".txt", ".py")  # 想監控的副檔名，可自行擴充

# --- 排除的檔案或資料夾 ---
$excludeFiles = @("autogit.ps1","workflow.bat")  # 自動工具
$excludeFolders = @(".git")                      # Git 資料夾

# -------------------------------
# 事件觸發的工作流函數
# -------------------------------

function GitWorkflow($file) {
    cd $repo
    Write-Host " [Git] git add ."
    git add .
    $timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    Write-Host " [Git] git commit -m 'Auto Commit - $timestamp'"
    git commit -m "Auto Commit - $timestamp" 2>$null
    Write-Host " [Git] git push origin main 2>$null"
    git push origin main 2>$null
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

# 主工作流，新增工作流只需加函數即可
function RunWorkflows($file) {
    GitWorkflow $file
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
