@echo off
title Ripristino File Originali Aniimo

cd /d "%~dp0"

powershell.exe -File "%~dp0Ripristina_Originale.ps1"
if errorlevel 1 pause
