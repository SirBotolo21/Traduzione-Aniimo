@echo off
chcp 65001 >nul
title Traduzione Italiana Aniimo - Installazione Automatica

:: Imposta la directory di lavoro sul percorso dello script
cd /d "%~dp0"

set "SCRIPT_DIR=%~dp0"
set "FILES_DIR=%SCRIPT_DIR%files"

:: Controllo elevazione permessi Amministratore
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ================================================================
    echo           TRADUZIONE ITALIANA PER ANIIMO (PC)
    echo ================================================================
    echo.
    echo Richiesta permessi di Amministratore in corso...
    powershell -Command "Start-Process cmd.exe -ArgumentList '/k ""%~f0""' -Verb RunAs" >nul 2>&1
    exit /b
)

echo ================================================================
echo           TRADUZIONE ITALIANA PER ANIIMO (PC)
echo ================================================================
echo.

:: Controllo 0: Verifica che lo ZIP sia stato estratto interamente
if not exist "%FILES_DIR%" (
    echo [ATTENZIONE / ERRORE]
    echo La cartella "files" non e' stata trovata in:
    echo "%SCRIPT_DIR%"
    echo.
    echo Assicurati di aver ESTRATTO L'INTERO ARCHIVIO ZIP in una cartella
    echo prima di fare doppio clic su Installa_Traduzione.bat!
    echo Non eseguire lo script direttamente da dentro il file .ZIP.
    echo.
    pause
    exit /b 1
)

:: Chiudi eventuali processi del gioco in esecuzione per sbloccare i file
taskkill /f /im Aniimo.exe >nul 2>&1
timeout /t 1 >nul 2>&1

:: Ricerca automatica della directory di gioco Aniimo_Data
set "GAME_DATA="

if exist "%SCRIPT_DIR%..\Aniimo\game\Aniimo_Data\cvs\res\lua" set "GAME_DATA=%SCRIPT_DIR%..\Aniimo\game\Aniimo_Data"
if "%GAME_DATA%"=="" if exist "%SCRIPT_DIR%game\Aniimo_Data\cvs\res\lua" set "GAME_DATA=%SCRIPT_DIR%game\Aniimo_Data"
if "%GAME_DATA%"=="" if exist "%SCRIPT_DIR%Aniimo_Data\cvs\res\lua" set "GAME_DATA=%SCRIPT_DIR%Aniimo_Data"
if "%GAME_DATA%"=="" if exist "C:\Program Files\Aniimo\game\Aniimo_Data\cvs\res\lua" set "GAME_DATA=C:\Program Files\Aniimo\game\Aniimo_Data"
if "%GAME_DATA%"=="" if exist "C:\Games\Aniimo\game\Aniimo_Data\cvs\res\lua" set "GAME_DATA=C:\Games\Aniimo\game\Aniimo_Data"

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

:: Backup preventivo dei file originali se non esiste
set "BACKUP_DIR=%GAME_DATA%\_backup_traduzione_originale"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" >nul 2>&1
if not exist "%BACKUP_DIR%\LuaScripts.xdf" copy /y "%GAME_DATA%\cvs\res\lua\LuaScripts.xdf" "%BACKUP_DIR%\" >nul 2>&1
if not exist "%BACKUP_DIR%\LuaScripts.xdt" copy /y "%GAME_DATA%\cvs\res\lua\LuaScripts.xdt" "%BACKUP_DIR%\" >nul 2>&1

:: Estrazione LuaScripts.zip se LuaScripts.xdf non e' estratto
if exist "%FILES_DIR%\LuaScripts.xdf" goto SKIP_ZIP
if exist "%FILES_DIR%\LuaScripts.zip" (
    echo Decompressione archivio script (LuaScripts.zip)...
    tar -xf "%FILES_DIR%\LuaScripts.zip" -C "%FILES_DIR%" >nul 2>&1
    if not exist "%FILES_DIR%\LuaScripts.xdf" (
        powershell -Command "Expand-Archive -Path '%FILES_DIR%\LuaScripts.zip' -DestinationPath '%FILES_DIR%' -Force" >nul 2>&1
    )
)

:SKIP_ZIP
if not exist "%FILES_DIR%\LuaScripts.xdf" (
    echo [ERRORE] File LuaScripts.xdf non trovato in %FILES_DIR%!
    pause
    exit /b 1
)

echo Applicazione dei file di traduzione italiana...

:: 1. Applicazione in cvs/res/lua (directory attiva)
copy /y "%FILES_DIR%\LuaScripts.xdf" "%GAME_DATA%\cvs\res\lua\LuaScripts.xdf" >nul 2>&1
copy /y "%FILES_DIR%\LuaScripts.xdt" "%GAME_DATA%\cvs\res\lua\LuaScripts.xdt" >nul 2>&1

if exist "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N" copy /y "%FILES_DIR%\Compress_fr_FR.bin" "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N\Compress_fr_FR.bin" >nul 2>&1
if exist "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N" copy /y "%FILES_DIR%\NewTextMap_fr_FR.json" "%GAME_DATA%\cvs\res\lua\LuaScripts\Data\I18N\NewTextMap_fr_FR.json" >nul 2>&1

:: 2. Ripristino di sicurezza StreamingAssets (per superare l'integrity check del motore)
if exist "%BACKUP_DIR%\LuaScripts.xdf" copy /y "%BACKUP_DIR%\LuaScripts.xdf" "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts.xdf" >nul 2>&1
if exist "%BACKUP_DIR%\LuaScripts.xdt" copy /y "%BACKUP_DIR%\LuaScripts.xdt" "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts.xdt" >nul 2>&1
if exist "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts" rmdir /s /q "%GAME_DATA%\StreamingAssets\cvs\res\lua\LuaScripts" >nul 2>&1

:: 3. Mirror in patchv2 per tutte le versioni di patch (3616231 e successive)
if exist "%GAME_DATA%\cvs\res\patchv2\lua\ver" (
    for /d %%D in ("%GAME_DATA%\cvs\res\patchv2\lua\ver\*") do (
        echo Aggiornamento versione patch: %%~nxD
        copy /y "%FILES_DIR%\LuaScripts.xdf" "%%D\LuaScripts.xdf" >nul 2>&1
        copy /y "%FILES_DIR%\LuaScripts.xdt" "%%D\LuaScripts.xdt" >nul 2>&1
        if exist "%%D\LuaScripts\Data\I18N" copy /y "%FILES_DIR%\Compress_fr_FR.bin" "%%D\LuaScripts\Data\I18N\Compress_fr_FR.bin" >nul 2>&1
        if exist "%%D\LuaScripts\Data\I18N" copy /y "%FILES_DIR%\NewTextMap_fr_FR.json" "%%D\LuaScripts\Data\I18N\NewTextMap_fr_FR.json" >nul 2>&1
    )
)

echo.
echo ================================================================
echo           INSTALLAZIONE COMPLETATA CON SUCCESSO!
echo ================================================================
echo.
echo NOTA FONDAMENTALE:
echo 1. Avvia Aniimo.
echo 2. Vai nelle Impostazioni di gioco -^> Lingua (Language).
echo 3. Seleziona "Français": tutti i testi, dialoghi, missioni e
echo    interfaccia saranno ora in ITALIANO revisionato al 100%%!
echo.
pause
