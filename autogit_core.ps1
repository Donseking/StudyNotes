$repo = "D:\DSKCODE\STUDYNOTES"
$cooldownSeconds = 10
$lastRun = Get-Date "2000-01-01"

$Host.UI.RawUI.WindowTitle = "AutoGitWatcher"

Write-Host "AutoGit �t�αҰʤ�..."
Write-Host "�ʱ����|�G$repo"
Write-Host "�N�o���j�G$cooldownSeconds ��"
Write-Host "------------------------------------------"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repo
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    $changedFile = $Event.SourceEventArgs.FullPath

    # �ư� .git �P�۰ʤu���ɮ�
    if ($changedFile -match "\\.git\\") { return }
    $excludeFiles = @("autogit.ps1","workflow.bat")
    foreach ($f in $excludeFiles) {
        if ($changedFile -like "*$f") { return }
    }

    # �ˬd���ɦW
    $allowedExt = @(".md", ".txt", ".py")
    if ($allowedExt -notcontains [System.IO.Path]::GetExtension($changedFile)) { return }

    # �N�o
    $now = Get-Date
    if (($now - $lastRun).TotalSeconds -lt $cooldownSeconds) { return }
    $global:lastRun = $now

    Write-Host "`n �������ܧ�G$changedFile"
    Write-Host " ����۰ʱ��e�y�{..."

    # Git �ާ@
    cd $repo
    git status
    Write-Host " git add ."
    git add .
    $timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    Write-Host " git commit -m 'Auto Commit - $timestamp'"
    git commit -m "Auto Commit - $timestamp" 2>$null
    Write-Host " git push origin main 2>$null"
    git push origin main 2>$null

    Write-Host " ���e�����I [$timestamp]"
}

while ($true) { Start-Sleep 5 }
