@echo off
setlocal enabledelayedexpansion

set "repo=D:\DSKCODE\STUDYNOTES"
set "ps1=%repo%\autogit_core.ps1"

:: =========================
:: �۰� Git �t�α��
:: =========================
if "%1"=="start" (
    echo  �Ұʦ۰� Git �t��...
    powershell -ExecutionPolicy Bypass -File "%ps1%"
    exit /b
)

if "%1"=="stop" (
    echo  ���ղפ�۰� Git �t��...
    taskkill /FI "WINDOWTITLE eq AutoGitWatcher" /F >nul 2>nul
    echo  �w����ʱ��C
    exit /b
)

echo -----------------------------------------
echo  �ϥΤ覡�G
echo   autogit start    �Ұʦ۰ʱ��e�t��
echo   autogit stop     ����۰ʱ��e�t��
echo -----------------------------------------
exit /b
