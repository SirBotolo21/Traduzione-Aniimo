@echo off
chcp 65001 >nul
title Ripristino File Originali - Aniimo
echo ================================================================
echo           RIPRISTINO FILE ORIGINALI ANIIMO
echo ================================================================
echo.

set "SCRIPT_DIR=%~dp0"

:: Ricerca automatica della directory di gioco Aniimo_Data
set "GAME_DATA="

if exist "%SCRIPT_DIR%..\Aniimo\game\Aniimo_Data" (
    set "GAME_DATA=%SCRIPT_DIR%..\Aniimo\game\Aniimo_Data"
)

if exist "%SCRIPT_DIR%game\Aniimo_Data" (
    set "GAME_DATA=%SCRIPT_DIR%game\Aniimo_Data"
)

if exist "%SCRIPT_DIR%Aniimo_Data" (
    set "GAME_DATA=%SCRIPT_DIR%Aniimo_Data"
)

if "%GAME_DATA%"=="" (
    echo Cartella del gioco non rilevata automaticamente.
    echo Inserisci il percorso completo della cartella Aniimo_Data:
    set /p "GAME_DATA=> "
)

set "BACKUP_DIR=%GAME_DATA%\_backup_traduzione_originale"
if not exist "%BACKUP_DIR%\LuaScripts.xdf" (
    echo [ERRORE] Nessun backup trovato in:
    echo "%BACKUP_DIR%"
    pause
    exit /b 1
)

echo Ripristino in corso dai file salvati in:
echo "%BACKUP_DIR%"

copy /y "%BACKUP_DIR%\LuaScripts.xdf" "%GAME_DATA%\cvs\res\lua\LuaScripts.xdf" >nul
copy /y "%BACKUP_DIR%\LuaScripts.xdt" "%GAME_DATA%\cvs\res\lua\LuaScripts.xdt" >nul

if exist "%GAME_DATA%\StreamingAssets\cvs\res\lua" (
    copy /y "%BACKUP_DIR%\LuaScripts.xdf" "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts.xdf" >nul
    copy /y "%BACKUP_DIR%\LuaScripts.xdt" "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts.xdt" >nul
)

for /d %%D in ("%GAME_DATA%\cvs\res\patchv2\lua\ver\*") do (
    copy /y "%BACKUP_DIR%\LuaScripts.xdf" "%%D\LuaScripts.xdf" >nul
    copy /y "%BACKUP_DIR%\LuaScripts.xdt" "%%D\LuaScripts.xdt" >nul
)

echo.
echo ================================================================
echo           RIPRISTINO COMPLETATO CON SUCCESSO!
echo ================================================================
pause
