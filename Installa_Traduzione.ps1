# ================================================================
#          TRADUZIONE ITALIANA PER ANIIMO (PC)
#             Script di Installazione PowerShell
# ================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Traduzione Italiana Aniimo - Installazione Automatica"

# Imposta la cartella di lavoro sulla posizione dello script
$ScriptDir = $PSScriptRoot
if (-not $ScriptDir) { $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition }
Set-Location -Path $ScriptDir

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "          TRADUZIONE ITALIANA PER ANIIMO (PC)" -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

$FilesDir = Join-Path $ScriptDir "files"

# 1. Verifica estrazione dello ZIP
if (-not (Test-Path $FilesDir)) {
    Write-Host "[ERRORE FONDAMENTALE]" -ForegroundColor Red
    Write-Host "La cartella 'files' non è stata trovata in:" -ForegroundColor Red
    Write-Host "  $ScriptDir" -ForegroundColor White
    Write-Host ""
    Write-Host "Assicurati di aver ESTRATTO L'INTERO ARCHIVIO ZIP in una cartella" -ForegroundColor Yellow
    Write-Host "prima di eseguire lo script! Non eseguirlo da dentro il file .ZIP." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Premi Invio per chiudere..."
    exit 1
}

$TempDir = Join-Path $FilesDir "temp"
if (-not (Test-Path $TempDir)) {
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
}

# 2. Chiudi il gioco se in esecuzione per sbloccare i file
$gameProcesses = Get-Process -Name "Aniimo" -ErrorAction SilentlyContinue
if ($gameProcesses) {
    Write-Host "Chiusura del processo Aniimo.exe in corso..." -ForegroundColor DarkYellow
    Stop-Process -Name "Aniimo" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# 3. Ricerca automatica della directory Aniimo_Data
$GameData = $null

$candidates = @(
    (Join-Path $ScriptDir "..\Aniimo\game\Aniimo_Data"),
    (Join-Path $ScriptDir "game\Aniimo_Data"),
    (Join-Path $ScriptDir "Aniimo_Data"),
    "C:\Program Files\Aniimo\game\Aniimo_Data",
    "C:\Games\Aniimo\game\Aniimo_Data",
    "D:\PawPrint\Aniimo\game\Aniimo_Data"
)

foreach ($c in $candidates) {
    if (Test-Path (Join-Path $c "cvs\res\lua")) {
        $GameData = (Get-Item $c).FullName
        break
    }
}

if (-not $GameData) {
    Write-Host "Cartella del gioco non rilevata automaticamente." -ForegroundColor Yellow
    $userInput = Read-Host "Inserisci il percorso completo della cartella Aniimo_Data"
    if ($userInput -and (Test-Path (Join-Path $userInput "cvs\res\lua"))) {
        $GameData = (Get-Item $userInput).FullName
    }
}

if (-not $GameData -or -not (Test-Path (Join-Path $GameData "cvs\res\lua"))) {
    Write-Host ""
    Write-Host "[ERRORE] Percorso non valido o cartella Aniimo_Data non riconosciuta!" -ForegroundColor Red
    Write-Host "Assicurati che contenga la sottocartella 'cvs\res\lua'." -ForegroundColor Red
    Write-Host ""
    Read-Host "Premi Invio per chiudere..."
    exit 1
}

Write-Host "Cartella di gioco trovata: " -NoNewline -ForegroundColor Green
Write-Host "$GameData" -ForegroundColor White
Write-Host ""

# 4. Creazione backup preventivo
$BackupDir = Join-Path $GameData "_backup_traduzione_originale"
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    $origXdf = Join-Path $GameData "cvs\res\lua\LuaScripts.xdf"
    $origXdt = Join-Path $GameData "cvs\res\lua\LuaScripts.xdt"
    if (Test-Path $origXdf) { Copy-Item -Path $origXdf -Destination $BackupDir -Force }
    if (Test-Path $origXdt) { Copy-Item -Path $origXdt -Destination $BackupDir -Force }
}

# 5. Decompressione LuaScripts.zip se necessario
$xdfFile = Join-Path $FilesDir "LuaScripts.xdf"
$zipFile = Join-Path $FilesDir "LuaScripts.zip"

if (-not (Test-Path $xdfFile) -and (Test-Path $zipFile)) {
    Write-Host "Decompressione archivio script (LuaScripts.zip)..." -ForegroundColor Cyan
    Expand-Archive -Path $zipFile -DestinationPath $FilesDir -Force
}

if (-not (Test-Path $xdfFile)) {
    Write-Host "[ERRORE] File LuaScripts.xdf non trovato in $FilesDir!" -ForegroundColor Red
    Read-Host "Premi Invio per chiudere..."
    exit 1
}

# 6. Applicazione Traduzione Italiana
Write-Host "Applicazione dei file di traduzione italiana..." -ForegroundColor Cyan

$srcXdf = Join-Path $FilesDir "LuaScripts.xdf"
$srcXdt = Join-Path $FilesDir "LuaScripts.xdt"
$srcBin = Join-Path $FilesDir "Compress_fr_FR.bin"
$srcMap = Join-Path $FilesDir "NewTextMap_fr_FR.json"

# A. cvs/res/lua
$targetLua = Join-Path $GameData "cvs\res\lua"
if (Test-Path $targetLua) {
    Copy-Item -Path $srcXdf -Destination $targetLua -Force
    Copy-Item -Path $srcXdt -Destination $targetLua -Force
    $i18nDir = Join-Path $targetLua "LuaScripts\Data\I18N"
    if (Test-Path $i18nDir) {
        if (Test-Path $srcBin) { Copy-Item -Path $srcBin -Destination $i18nDir -Force }
        if (Test-Path $srcMap) { Copy-Item -Path $srcMap -Destination $i18nDir -Force }
    }
}

# B. StreamingAssets (Sicurezza)
$streamLua = Join-Path $GameData "StreamingAssets\cvs\res\lua"
if (Test-Path (Join-Path $BackupDir "LuaScripts.xdf")) {
    Copy-Item -Path (Join-Path $BackupDir "LuaScripts.xdf") -Destination $streamLua -Force -ErrorAction SilentlyContinue
    Copy-Item -Path (Join-Path $BackupDir "LuaScripts.xdt") -Destination $streamLua -Force -ErrorAction SilentlyContinue
}

# C. Allineamento Patch patchv2
$patchBase = Join-Path $GameData "cvs\res\patchv2\lua\ver"
if (Test-Path $patchBase) {
    Get-ChildItem -Path $patchBase -Directory | ForEach-Object {
        $verDir = $_.FullName
        Write-Host "  -> Aggiornamento versione patch: $($_.Name)" -ForegroundColor DarkGray
        Copy-Item -Path $srcXdf -Destination $verDir -Force -ErrorAction SilentlyContinue
        Copy-Item -Path $srcXdt -Destination $verDir -Force -ErrorAction SilentlyContinue
        $i18nVer = Join-Path $verDir "LuaScripts\Data\I18N"
        if (Test-Path $i18nVer) {
            if (Test-Path $srcBin) { Copy-Item -Path $srcBin -Destination $i18nVer -Force -ErrorAction SilentlyContinue }
            if (Test-Path $srcMap) { Copy-Item -Path $srcMap -Destination $i18nVer -Force -ErrorAction SilentlyContinue }
        }
    }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "          INSTALLAZIONE COMPLETATA CON SUCCESSO!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "NOTA FONDAMENTALE:" -ForegroundColor Yellow
Write-Host "1. Avvia Aniimo."
Write-Host "2. Vai nelle Impostazioni di gioco -> Lingua (Language)."
Write-Host "3. Seleziona 'Français': tutti i testi, dialoghi, missioni e"
Write-Host "   interfaccia saranno ora in ITALIANO revisionato al 100%!"
Write-Host ""

Read-Host "Premi Invio per uscire..."
