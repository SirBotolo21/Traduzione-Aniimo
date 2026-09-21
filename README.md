# Traduzione Italiana Completa per Aniimo (PC)

Benvenuto nel progetto di **traduzione e revisione italiana completa** per il gioco **Aniimo** (PC).

Questa patch sostituisce la lingua francese (`fr_FR`) integrando una localizzazione italiana integrale, accurata e revisionata riga per riga su tutte le **112.187 stringhe** del gioco, risolvendo bug grafici, tag corrotti e formule troncate dei vecchi adattamenti automatici.

---

## 🌟 Caratteristiche Principali della Traduzione

1. **Revisione Totale di 112.187 Stringhe**:
   - Trama principale, dialoghi di tutti i capitoli e atti, missioni secondarie e incontri nel mondo interamente in italiano.
   - Eliminazione completa di frasi in inglese residue.
2. **Pulsanti e Interfaccia di Gioco (UI)**:
   - Correzione di tutti i pulsanti fraintesi dai traduttori automatici:
     - *Wave* -> **"Ondata"** (sfide a ondate, non più *"Saluta"*).
     - *Floor %s/%s* -> **"Piano %s/%s"** (non più *"Pavimento"*).
     - *Drop* -> **"Lascia"** (lasciare oggetti a terra, non più *"Goccia"*).
     - *Speed Up* -> **"Accelera"** (non più *"Velocità in su"*).
     - *Ascending / Descending* -> **"Crescente / Decrescente"** (filtri inventario).
     - *Deselect All* -> **"Deseleziona tutto"**.
     - *Hot* -> **"In evidenza"** (etichette shop, non più *"Caldo"*).
     - *Warehouse* -> **"Magazzino"**.
3. **Schermate di Caricamento e Download**:
   - Schermate di caricamento, avvisi di sistema e barre di download uniformati in italiano (*"Download in corso"*, *"Download risorse: {0}"*, *"Caricamento posta..."*).
4. **Ripristino Formule e Tag Unity RichText**:
   - Corrette le formule matematiche e i tag numerici che causavano testi spazzatura o blocchi (come `⟦000[[Armeria di fognatura]`, formule `μm μm >` o stringhe scramble nella Dimora).
5. **Integrità e Sincronizzazione Perfetta**:
   - File archiviati in formato nativo `LuaScripts.xdf` con ricalcolo esatto degli offset binari e del manifest MD5 `LuaScripts.xdt`.

---

## 🚀 Come Installare la Traduzione

### Metodo 1: Installazione Automatica (Consigliato)
1. Chiudi il gioco se è in esecuzione.
2. Fai doppio clic sul file **`Installa_Traduzione.bat`**.
3. Lo script troverà automaticamente la cartella di installazione del gioco, creerà una copia di backup dei file originali e installerà la traduzione.
4. Premi un tasto per chiudere.

### Metodo 2: Installazione Manuale
Se preferisci copiare i file a mano, copia i file presenti nella cartella `files/`:
* `LuaScripts.xdf`
* `LuaScripts.xdt`
* `Compress_fr_FR.bin`

Nelle seguenti cartelle all'interno della directory di gioco `Aniimo_Data`:

1. `Aniimo_Data/cvs/res/lua/`
2. `Aniimo_Data/StreamingAssets/cvs/res/lua/`
3. `Aniimo_Data/cvs/res/patchv2/lua/ver/3544783/` *(o eventuale cartella di versione numerata presente)*

---

## 🎮 Come Attivare l'Italiano nel Gioco

Poiché il gioco non dispone nativamente di una voce "Italiano" nel menu:
1. Avvia **Aniimo**.
2. Apri le **Impostazioni (Settings)** dal menu principale o in-game.
3. Vai nella scheda **Lingua (Language)**.
4. Seleziona **Français (Francese)**.
5. Tutti i testi, i menu, i filmati, i dialoghi e le descrizioni appariranno magicamente in **Italiano**!

---

## 🔄 Come Ripristinare i File Originali

Se desideri disinstallare la traduzione:
* Esegui semplicemente **`Ripristina_Originale.bat`**;
* Lo script ripristinerà i file originali salvati durante la prima installazione nella cartella `_backup_traduzione_originale`.

---

## 📁 Struttura del Progetto

```text
Traduzione-Aniimo/
├── Installa_Traduzione.bat       # Installer con backup automatico
├── Ripristina_Originale.bat      # Disinstaller per ripristinare il backup
├── README.md                     # Guida completa e documentazione
├── GUIDA_GIOCO.md                # Guida completa di gioco (Trama, Missioni, Meccaniche)
└── files/
    ├── LuaScripts.zip            # Archivio compresso script e testi di gioco (estratto automaticamente)
    ├── LuaScripts.xdt            # Manifest con offset e checksum MD5
    ├── Compress_fr_FR.bin        # Dizionario binario delle stringhe italiane
    └── NewTextMap_fr_FR.json     # Mappa di puntamento degli indici
```

---

## 📖 Guida Completa al Gioco
All'interno del repository trovi il file **[`GUIDA_GIOCO.md`](GUIDA_GIOCO.md)**, una guida dettagliata e approfondita redatta analizzando direttamente i dialoghi e i dati di missione di Aniimo:
* **Trama Principale**: Walkthrough completo degli Atti da 1 a 10.
* **Tutte le Grandi Missioni Viaggio (*Journey Quests*)**: *Stelle e il Cavaliere*, *Guerriero*, *Una Risposta dal Cielo*, *Fentufts e i Nimbi*, *Giuramento Vincolante*, *La Leggenda di Armand*.
* **Meccaniche di Gioco & Segreti**: Formule di cattura con Aniipod, legame *Twine*, barra *BREAK*, gestione della Dimora e risveglio del Flusso Prismatico.
* **Boss Rush & Addestramento Elite**.


---

## 💬 Community e Discussioni
Hai dubbi sull'installazione, vuoi segnalare un refuso o discutere delle strategie di gioco?
* Partecipa alla sezione ufficiale: **[GitHub Discussions](https://github.com/sirbotolos-crypto/Traduzione-Aniimo/discussions)**!

---

## 📜 Note e Crediti
* **Traduzione e revisione a cura di**: **SirBotolo** (sirbotolos-crypto).
* **Guida ufficiale al gioco a cura di**: **SirBotolo**.
* Compatibile con la versione PC attuale di Aniimo.
