@echo off
setlocal enabledelayedexpansion

:: ==============================
:: Git ??????
:: ==============================

cd /d D:\DSKCODE\STUDYNOTES

echo -------------------------------------
echo ?? ??????...
echo -------------------------------------

git status
git add .
git commit -m "Auto Commit"
git push origin main

echo ? ????!
echo -------------------------------------
pause
