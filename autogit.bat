@echo off
setlocal enabledelayedexpansion

set "repo=D:\DSKCODE\STUDYNOTES"
set "ps1=%repo%\autogit_core.ps1"

:: =========================
:: ?? Git ?????
:: =========================
if "%1"=="start" (
    echo ?? ???? Git ??...
    powershell -ExecutionPolicy Bypass -File "%ps1%"
    exit /b
)

if "%1"=="stop" (
    echo ?? ?????? Git ??...
    taskkill /FI "WINDOWTITLE eq AutoGitWatcher" /F >nul 2>nul
    echo ? ??????
    exit /b
)

echo -----------------------------------------
echo ?? ????:
echo   autogit start    ????????
echo   autogit stop     ????????
echo -----------------------------------------
exit /b
