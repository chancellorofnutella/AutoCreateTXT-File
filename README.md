# Daily Note Creator

A tiny PowerShell script that automatically creates a new `.txt` file every day at midnight, named with the date (e.g. `08.15.2026.txt`). Handy for keeping daily notes without having to remember to create the file yourself.

## What it does

- Runs once a day (via Windows Task Scheduler)
- Creates a text file named `MM.dd.yyyy.txt` in the same folder as the script
- If a file for that day already exists, it leaves it alone (won't overwrite your notes)

## Setup

### 1. Save the script

Put `Create Daily Note.ps1` in whatever folder you want your daily notes to live in. The script always creates the day's file in the same folder it's saved in, so pick that location first.

### 2. Open Task Scheduler

Press the Windows key, type **Task Scheduler**, and open it.

### 3. Create a new task

In the right-hand pane, click **Create Task...** (not "Create Basic Task"). Give it a name, e.g. `Daily Note Creator`.

### 4. Set the trigger

- Go to the **Triggers** tab → **New**
- Set "Begin the task" to **On a schedule**
- Choose **Daily**
- Set the start time to `12:00:00 AM`
- Make sure it recurs every 1 day
- Click **OK**

### 5. Set the action

- Go to the **Actions** tab → **New**
- Set Action to **Start a program**
- **Program/script:** `powershell.exe`
- **Add arguments:**
  ```
  -ExecutionPolicy Bypass -File "C:\Path\To\YourFolder\Create Daily Note.ps1"
  ```
  Replace `C:\Path\To\YourFolder\` with the actual full path to wherever you saved the script.
- Click **OK**

### 6. Adjust conditions (optional)

On the **Conditions** tab, if this is a laptop, uncheck "Start the task only if the computer is on AC power" so it still runs on battery.

### 7. Save

Click **OK** to save the task. Windows may ask for your account password since the task can run whether you're logged in or not.

## Notes

- Both the **Program/script** and **Add arguments** fields must be filled in separately — don't put the whole command line into one box, or Task Scheduler will try to run the wrong thing.
- Double-check every backslash `\` in your path — a missing one is the most common setup mistake.
- If you move the script to a different folder later, just update the path in the task's Action — no changes needed to the script itself.

## The script

```powershell
$archivePath = Split-Path -Parent $PSCommandPath
$fileName = (Get-Date -Format 'MM.dd.yyyy') + '.txt'
New-Item -ItemType File -Path (Join-Path $archivePath $fileName) -Force | Out-Null
```

## Cloud Compatibility

If you want your daily notes to automatically back up to the cloud, use `Create Daily Note (Cloud).ps1` instead of the standard version.

This version separates where the **script** lives from where the **notes** get saved:

- Keep the script itself in a normal local folder (e.g. `C:\Scripts\` or `C:\Users\YourName\Documents\DailyNotesScript\`)
- Set the `$notesFolder` variable at the top of the script to a folder inside your Google Drive (or OneDrive, Dropbox, etc.) sync folder

This way your notes automatically sync to the cloud, but the script that creates them doesn't depend on the cloud service being fully synced or running at the moment it fires — it just writes locally to a folder that happens to be watched by your sync client.

### Setup differences from the standard version

1. Open the script in a text editor and update this line near the top:
   ```powershell
   $notesFolder = "C:\Path\To\YourFolder\GoogleDrive\DailyNotes"
   ```
   Replace it with the actual path to your Google Drive (or other cloud) synced folder.
2. Point Task Scheduler's **Add arguments** field at wherever you saved *this* script file — the script folder and the notes folder no longer need to match.

### The cloud-compatible script

```powershell
# ---- CONFIGURE THIS ----
# Set this to the folder you want your daily notes saved in.
# This can be a folder inside your Google Drive (or OneDrive/Dropbox) sync folder,
# so your notes automatically back up to the cloud.
$notesFolder = "C:\Path\To\YourFolder\GoogleDrive\DailyNotes"
# -------------------------

# Create the notes folder if it doesn't already exist
New-Item -ItemType Directory -Path $notesFolder -Force | Out-Null

# Create today's note file (won't overwrite if it already exists)
$fileName = (Get-Date -Format 'MM.dd.yyyy') + '.txt'
New-Item -ItemType File -Path (Join-Path $notesFolder $fileName) -Force | Out-Null
```
