@echo off
chcp 65001 >nul
title Traduzione Italiana Aniimo - Installazione Automatica
echo ================================================================
echo           TRADUZIONE ITALIANA PER ANIIMO (PC)
echo ================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "FILES_DIR=%SCRIPT_DIR%files"

:: Ricerca automatica della directory di gioco Aniimo_Data
set "GAME_DATA="

:: Controllo 1: Cartella adiacente
if exist "%SCRIPT_DIR%..\Aniimo\game\Aniimo_Data" (
    set "GAME_DATA=%SCRIPT_DIR%..\Aniimo\game\Aniimo_Data"
)

:: Controllo 2: Se lo script e' dentro la root di Aniimo
if exist "%SCRIPT_DIR%game\Aniimo_Data" (
    set "GAME_DATA=%SCRIPT_DIR%game\Aniimo_Data"
)

:: Se non trovata automaticamente, chiedi all'utente
if "%GAME_DATA%"=="" (
    echo Cartella del gioco non rilevata automaticamente.
    echo Inserisci il percorso completo della cartella Aniimo_Data:
    set /p "GAME_DATA=> "
)

if not exist "%GAME_DATA%\cvs\res\lua" (
    echo.
    echo [ERRORE] Percorso non valido o cartella Aniimo_Data non riconosciuta!
    echo Percorso indicato: "%GAME_DATA%"
    echo Assicurati che contenga la sottocartella "cvs\res\lua".
    pause
    exit /b 1
)

echo Cartella di gioco trovata: "%GAME_DATA%"
echo.

:: Creazione backup preventivo se non esiste
set "BACKUP_DIR=%GAME_DATA%\_backup_traduzione_originale"
if not exist "%BACKUP_DIR%" (
    echo Creazione backup dei file originali in:
    echo "%BACKUP_DIR%"
    mkdir "%BACKUP_DIR%" >nul 2>&1
    copy /y "%GAME_DATA%\cvs\res\lua\LuaScripts.xdf" "%BACKUP_DIR%\" >nul
    copy /y "%GAME_DATA%\cvs\res\lua\LuaScripts.xdt" "%BACKUP_DIR%\" >nul
    if exist "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N\Compress_fr_FR.bin" (
        copy /y "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N\Compress_fr_FR.bin" "%BACKUP_DIR%\" >nul
    )
:: Decompressione di LuaScripts.zip se non ancora estratto
if not exist "%FILES_DIR%\LuaScripts.xdf" (
    if exist "%FILES_DIR%\LuaScripts.zip" (
        echo Decompressione archivio script (LuaScripts.zip)...
        tar -xf "%FILES_DIR%\LuaScripts.zip" -C "%FILES_DIR%" >nul 2>&1
        if not exist "%FILES_DIR%\LuaScripts.xdf" (
            powershell -Command "Expand-Archive -Path '%FILES_DIR%\LuaScripts.zip' -DestinationPath '%FILES_DIR%' -Force" >nul 2>&1
        )
    )
)

echo Applicazione dei file di traduzione italiana...

:: 1. Mirror cvs/res/lua
copy /y "%FILES_DIR%\LuaScripts.xdf" "%GAME_DATA%\cvs\res\lua\LuaScripts.xdf" >nul
copy /y "%FILES_DIR%\LuaScripts.xdt" "%GAME_DATA%\cvs\res\lua\LuaScripts.xdt" >nul
if exist "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N" (
    copy /y "%FILES_DIR%\Compress_fr_FR.bin" "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N\Compress_fr_FR.bin" >nul
)

:: 2. Mirror StreamingAssets
if exist "%GAME_DATA%\StreamingAssets\cvs\res\lua" (
    copy /y "%FILES_DIR%\LuaScripts.xdf" "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts.xdf" >nul
    copy /y "%FILES_DIR%\LuaScripts.xdt" "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts.xdt" >nul
    if exist "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts\Data\I18N" (
        copy /y "%FILES_DIR%\Compress_fr_FR.bin" "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts\Data\I18N\Compress_fr_FR.bin" >nul
    )
)

:: 3. Mirror patchv2 (se presente)
for /d %%D in ("%GAME_DATA%\cvs\res\patchv2\lua\ver\*") do (
    copy /y "%FILES_DIR%\LuaScripts.xdf" "%%D\LuaScripts.xdf" >nul
    copy /y "%FILES_DIR%\LuaScripts.xdt" "%%D\LuaScripts.xdt" >nul
    if exist "%%D\LuaScripts\Data\I18N" (
        copy /y "%FILES_DIR%\Compress_fr_FR.bin" "%%D\LuaScripts\Data\I18N\Compress_fr_FR.bin" >nul
    )
)

echo.
echo ================================================================
echo           INSTALLAZIONE COMPLETATA CON SUCCESSO!
echo ================================================================
echo.
echo NOTA FONDAMENTALE:
echo 1. Avvia Aniimo.
echo 2. Vai nelle Impostazioni di gioco -> Lingua (Language).
echo 3. Seleziona "Français": tutti i testi, dialoghi, missioni e
echo    interfaccia saranno ora in ITALIANO revisionato al 100%%!
echo.
pause
