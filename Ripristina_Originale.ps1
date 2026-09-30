# ================================================================
#          RIPRISTINO FILE ORIGINALI ANIIMO (PC)
#             Script di Ripristino PowerShell
# ================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Ripristino File Originali Aniimo"

# Imposta la cartella di lavoro sulla posizione dello script
$ScriptDir = $PSScriptRoot
if (-not $ScriptDir) { $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition }
Set-Location -Path $ScriptDir

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "           RIPRISTINO FILE ORIGINALI ANIIMO" -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Chiudi il gioco se in esecuzione per sbloccare i file
$gameProcesses = Get-Process -Name "Aniimo" -ErrorAction SilentlyContinue
if ($gameProcesses) {
    Write-Host "Chiusura del processo Aniimo.exe in corso..." -ForegroundColor DarkYellow
    Stop-Process -Name "Aniimo" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# 2. Ricerca automatica della directory Aniimo_Data su TUTTE le unita (C:, D:, E:, ecc.)
$GameData = $null

$localCandidates = @(
    (Join-Path $ScriptDir "..\Aniimo\game\Aniimo_Data"),
    (Join-Path $ScriptDir "game\Aniimo_Data"),
    (Join-Path $ScriptDir "Aniimo_Data")
)

foreach ($lc in $localCandidates) {
    if (Test-Path (Join-Path $lc "cvs\res\lua")) {
        $GameData = (Get-Item $lc).FullName
        break
    }
}

if (-not $GameData) {
    $drives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root
    foreach ($drive in $drives) {
        $driveCandidates = @(
            (Join-Path $drive "PawPrint\Aniimo\game\Aniimo_Data"),
            (Join-Path $drive "Aniimo\game\Aniimo_Data"),
            (Join-Path $drive "Games\Aniimo\game\Aniimo_Data"),
            (Join-Path $drive "Program Files\Aniimo\game\Aniimo_Data"),
            (Join-Path $drive "Program Files (x86)\Aniimo\game\Aniimo_Data"),
            (Join-Path $drive "SteamLibrary\steamapps\common\Aniimo\game\Aniimo_Data"),
            (Join-Path $drive "Epic Games\Aniimo\game\Aniimo_Data")
        )
        foreach ($c in $driveCandidates) {
            if (Test-Path (Join-Path $c "cvs\res\lua")) {
                $GameData = (Get-Item $c).FullName
                break
            }
        }
        if ($GameData) { break }
    }
}

# 3. Se non trovata automaticamente, chiedi all'utente tramite Dialog GUI o Testo
if (-not $GameData) {
    Write-Host "Cartella di gioco non rilevata automaticamente nei percorsi standard." -ForegroundColor Yellow
    Write-Host "Apertura finestra di selezione cartella..." -ForegroundColor Cyan
    
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.Description = "Seleziona la cartella di Aniimo per ripristinare il backup:"
        $dialog.ShowNewFolderButton = $false
        
        $result = $dialog.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK -and $dialog.SelectedPath) {
            $selected = $dialog.SelectedPath
            if (Test-Path (Join-Path $selected "cvs\res\lua")) {
                $GameData = $selected
            } elseif (Test-Path (Join-Path $selected "game\Aniimo_Data\cvs\res\lua")) {
                $GameData = Join-Path $selected "game\Aniimo_Data"
            } elseif (Test-Path (Join-Path $selected "Aniimo_Data\cvs\res\lua")) {
                $GameData = Join-Path $selected "Aniimo_Data"
            }
        }
    } catch {}
}

if (-not $GameData) {
    Write-Host ""
    Write-Host "Inserisci o trascina qui il percorso della cartella Aniimo_Data:" -ForegroundColor Yellow
    $userInput = Read-Host "Percorso"
    if ($userInput) {
        $cleanPath = $userInput.Trim('"').Trim("'")
        if (Test-Path (Join-Path $cleanPath "cvs\res\lua")) {
            $GameData = (Get-Item $cleanPath).FullName
        } elseif (Test-Path (Join-Path $cleanPath "game\Aniimo_Data\cvs\res\lua")) {
            $GameData = (Get-Item (Join-Path $cleanPath "game\Aniimo_Data")).FullName
        } elseif (Test-Path (Join-Path $cleanPath "Aniimo_Data\cvs\res\lua")) {
            $GameData = (Get-Item (Join-Path $cleanPath "Aniimo_Data")).FullName
        }
    }
}

if (-not $GameData -or -not (Test-Path (Join-Path $GameData "cvs\res\lua"))) {
    Write-Host ""
    Write-Host "[ERRORE] Percorso non valido o cartella Aniimo_Data non riconosciuta!" -ForegroundColor Red
    Write-Host ""
    Read-Host "Premi Invio per chiudere..."
    exit 1
}

# 4. Verifica esistenza backup
$BackupDir = Join-Path $GameData "_backup_traduzione_originale"
$backupXdf = Join-Path $BackupDir "LuaScripts.xdf"

if (-not (Test-Path $backupXdf)) {
    Write-Host ""
    Write-Host "[ERRORE] Nessun backup originale trovato in:" -ForegroundColor Red
    Write-Host "  $BackupDir" -ForegroundColor White
    Write-Host "Impossibile ripristinare senza una copia di sicurezza previa." -ForegroundColor Red
    Write-Host ""
    Read-Host "Premi Invio per chiudere..."
    exit 1
}

Write-Host "Ripristino file originali da: " -NoNewline -ForegroundColor Green
Write-Host "$BackupDir" -ForegroundColor White
Write-Host ""

$backupXdt = Join-Path $BackupDir "LuaScripts.xdt"

# 5. Ripristino cvs/res/lua
$targetLua = Join-Path $GameData "cvs\res\lua"
if (Test-Path $targetLua) {
    Copy-Item -Path $backupXdf -Destination $targetLua -Force
    if (Test-Path $backupXdt) { Copy-Item -Path $backupXdt -Destination $targetLua -Force }
    
    # Rimuovi eventuali file sciolti della traduzione
    $looseBin = Join-Path $targetLua "LuaScripts\Data\I18N\Compress_fr_FR.bin"
    $looseMap = Join-Path $targetLua "LuaScripts\Data\I18N\NewTextMap_fr_FR.json"
    if (Test-Path $looseBin) { Remove-Item -Path $looseBin -Force -ErrorAction SilentlyContinue }
    if (Test-Path $looseMap) { Remove-Item -Path $looseMap -Force -ErrorAction SilentlyContinue }
}

# 6. Ripristino StreamingAssets
$streamLua = Join-Path $GameData "StreamingAssets\cvs\res\lua"
if (Test-Path $streamLua) {
    Copy-Item -Path $backupXdf -Destination $streamLua -Force -ErrorAction SilentlyContinue
    if (Test-Path $backupXdt) { Copy-Item -Path $backupXdt -Destination $streamLua -Force -ErrorAction SilentlyContinue }
    $streamLoose = Join-Path $streamLua "LuaScripts"
    if (Test-Path $streamLoose) { Remove-Item -Path $streamLoose -Recurse -Force -ErrorAction SilentlyContinue }
}

# 7. Ripristino patchv2 subfolders
$patchBase = Join-Path $GameData "cvs\res\patchv2\lua\ver"
if (Test-Path $patchBase) {
    Get-ChildItem -Path $patchBase -Directory | ForEach-Object {
        $verDir = $_.FullName
        Write-Host "  -> Ripristino versione patch: $($_.Name)" -ForegroundColor DarkGray
        Copy-Item -Path $backupXdf -Destination $verDir -Force -ErrorAction SilentlyContinue
        if (Test-Path $backupXdt) { Copy-Item -Path $backupXdt -Destination $verDir -Force -ErrorAction SilentlyContinue }
        $verLooseBin = Join-Path $verDir "LuaScripts\Data\I18N\Compress_fr_FR.bin"
        $verLooseMap = Join-Path $verDir "LuaScripts\Data\I18N\NewTextMap_fr_FR.json"
        if (Test-Path $verLooseBin) { Remove-Item -Path $verLooseBin -Force -ErrorAction SilentlyContinue }
        if (Test-Path $verLooseMap) { Remove-Item -Path $verLooseMap -Force -ErrorAction SilentlyContinue }
    }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "          RIPRISTINO COMPLETATO CON SUCCESSO!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""

Read-Host "Premi Invio per uscire..."
