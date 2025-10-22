# -------------------------------
# AutoGit �ҲդƤu�@�y�ʱ��t��
# -------------------------------

$repo = "D:\DSKCODE\STUDYNOTES"
$cooldownSeconds = 10
$lastRun = Get-Date "2000-01-01"

$Host.UI.RawUI.WindowTitle = "AutoGitWatcher"

Write-Host "AutoGit �t�αҰʤ�..."
Write-Host "�ʱ����|�G$repo"
Write-Host "�N�o���j�G$cooldownSeconds ��"
Write-Host "------------------------------------------"

# --- �]�w�ʱ��ɮװ��ɦW ---
$allowedExt = @(".md", ".txt", ".py")  # �Q�ʱ������ɦW�A�i�ۦ��X�R

# --- �ư����ɮשθ�Ƨ� ---
$excludeFiles = @("autogit.ps1","workflow.bat")  # �۰ʤu��
$excludeFolders = @(".git")                      # Git ��Ƨ�

# -------------------------------
# �ƥ�Ĳ�o���u�@�y���
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
    Write-Host " [Git] ���e�����I [$timestamp]"
}

function BackupWorkflow($file) {
    $backupPath = "D:\Backup"
    if (-not (Test-Path $backupPath)) { New-Item -ItemType Directory -Path $backupPath | Out-Null }
    Copy-Item $file -Destination $backupPath -Force
    Write-Host " [Backup] �ƥ������G$file -> $backupPath"
}

function FormatWorkflow($file) {
    if ($file -like "*.py") {
        Write-Host " [Format] �榡�� Python: $file"
        black $file 2>$null
    }
}

function PdfWorkflow($file) {
    if ($file -like "*.md") {
        $pdfFile = "$($file -replace '\.md$', '.pdf')"
        Write-Host " [PDF] �ͦ� PDF: $pdfFile"
        pandoc $file -o $pdfFile 2>$null
    }
}

# �D�u�@�y�A�s�W�u�@�y�u�ݥ[��ƧY�i
function RunWorkflows($file) {
    GitWorkflow $file
}

# -------------------------------
# �]�w�ɮ׺ʱ�
# -------------------------------

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repo
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    $changedFile = $Event.SourceEventArgs.FullPath

    # �ư���Ƨ�
    foreach ($folder in $excludeFolders) {
        if ($changedFile -like "*\$folder\*") { return }
    }

    # �ư��ɮ�
    foreach ($f in $excludeFiles) {
        if ($changedFile -like "*$f") { return }
    }

    # ���ɦW�z��
    if ($allowedExt -notcontains [System.IO.Path]::GetExtension($changedFile)) { return }

    # �N�o����
    $now = Get-Date
    if (($now - $lastRun).TotalSeconds -lt $cooldownSeconds) { return }
    $global:lastRun = $now

    Write-Host "`n�������ܧ�G$changedFile"
    Write-Host " ����u�@�y..."
    RunWorkflows $changedFile
}

# -------------------------------
# ����B��
# -------------------------------
while ($true) { Start-Sleep 5 }
