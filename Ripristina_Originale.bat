@echo off
chcp 65001 >nul
title Ripristino File Originali Aniimo - Avvio PowerShell

cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Ripristina_Originale.ps1"

if %errorlevel% neq 0 (
    echo.
    echo Si e' verificato un errore durante l'esecuzione del ripristino.
    echo Premi un tasto per uscire...
    pause >nul
)
