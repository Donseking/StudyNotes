@echo off
setlocal enabledelayedexpansion

set "repo=D:\DSKCODE\STUDYNOTES"
set "ps1=%repo%\autogit_core.ps1"

:: =========================
:: 自動 Git 系統控制器
:: =========================
if "%1"=="start" (
    echo  啟動自動 Git 系統...
    powershell -ExecutionPolicy Bypass -File "%ps1%"
    exit /b
)

if "%1"=="stop" (
    echo  嘗試終止自動 Git 系統...
    taskkill /FI "WINDOWTITLE eq AutoGitWatcher" /F >nul 2>nul
    echo  已停止監控。
    exit /b
)

echo -----------------------------------------
echo  使用方式：
echo   autogit start    啟動自動推送系統
echo   autogit stop     停止自動推送系統
echo -----------------------------------------
exit /b
