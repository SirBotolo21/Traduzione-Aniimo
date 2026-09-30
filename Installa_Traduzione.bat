@echo off
chcp 65001 >nul
title Traduzione Italiana Aniimo - Avvio Installatore PowerShell

cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Installa_Traduzione.ps1"

if %errorlevel% neq 0 (
    echo.
    echo Si e' verificato un errore durante l'esecuzione dell'installatore.
    echo Premi un tasto per uscire...
    pause >nul
)
