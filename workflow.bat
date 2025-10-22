@echo off
setlocal enabledelayedexpansion

:: ==============================
:: Git 自動提交腳本
:: ==============================

cd D:\DSKCODE\STUDYNOTES

echo -------------------------------------
echo 🔄 自動提交開始...
echo -------------------------------------

git add .

:: 建立含時間的提交訊息
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    for /f "tokens=1 delims=: " %%e in ("%time%") do (
        set commitTime=%%a-%%b-%%c_%%e
    )
)
git commit -m "Auto Commit - %commitTime%"
git push origin main

echo ✅ 提交完成！
echo -------------------------------------
pause
