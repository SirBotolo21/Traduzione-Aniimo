@echo off
title Traduzione Italiana Aniimo

cd /d "%~dp0"

powershell.exe -File "%~dp0Installa_Traduzione.ps1"
if errorlevel 1 pause
