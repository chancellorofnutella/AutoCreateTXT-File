# Daily Note Creator — Cloud Compatible

This is a variant of [Daily Note Creator](README.md) that saves your daily notes into a cloud-synced folder (Google Drive, OneDrive, Dropbox, etc.), so your notes automatically back up without any extra effort.

## How it's different

The standard script always creates the day's `.txt` file in the same folder the script itself lives in. That's simple, but not ideal if you want that folder synced to the cloud — you generally don't want your automation scripts sitting inside a cloud sync folder.

This version separates the two:

1. **Keep the script itself in a normal local folder**, e.g. `C:\Scripts\` or `C:\Users\YourName\Documents\DailyNotesScript\`
2. **Have the script create the daily `.txt` files in a separate folder** that you *do* sync with Google Drive (or OneDrive, Dropbox, etc.)

That way your notes automatically appear in the cloud, but the script that creates them doesn't depend on the cloud service in any way.

## Setup

### 1. Save the script

Save `Create Daily Note (Cloud).ps1` anywhere local — it doesn't need to be inside your cloud sync folder.

### 2. Configure the notes folder

Open the script in a text editor and update this line near the top:

```powershell
$notesFolder = "C:\Path\To\YourFolder\GoogleDrive\DailyNotes"
```

Replace it with the actual path to a folder inside your Google Drive (or OneDrive/Dropbox) synced directory. If the folder doesn't exist yet, the script will create it automatically the first time it runs.

### 3. Open Task Scheduler

Press the Windows key, type **Task Scheduler**, and open it.

### 4. Create a new task

In the right-hand pane, click **Create Task...** (not "Create Basic Task"). Give it a name, e.g. `Daily Note Creator (Cloud)`.

### 5. Set the trigger

- Go to the **Triggers** tab → **New**
- Set "Begin the task" to **On a schedule**
- Choose **Daily**
- Set the start time to `12:00:00 AM`
- Make sure it recurs every 1 day
- Click **OK**

### 6. Set the action

- Go to the **Actions** tab → **New**
- Set Action to **Start a program**
- **Program/script:** `powershell.exe`
- **Add arguments:**
  ```
  -ExecutionPolicy Bypass -File "C:\Path\To\YourFolder\Create Daily Note (Cloud).ps1"
  ```
  Replace the path with wherever you saved *this* script file (not the notes folder).
- Click **OK**

### 7. Adjust conditions (optional)

On the **Conditions** tab, if this is a laptop, uncheck "Start the task only if the computer is on AC power" so it still runs on battery.

### 8. Save

Click **OK** to save the task. Windows may ask for your account password since the task can run whether you're logged in or not.

## Notes

- The script and the notes folder no longer need to be the same location — that's the whole point of this version.
- If your cloud sync client isn't running or fully synced at the moment the task fires, it doesn't matter — the script just writes a local file, and your sync client picks it up whenever it's next active.
- Both the **Program/script** and **Add arguments** fields must be filled in separately — don't combine them into one box.
- Double-check every backslash `\` in your paths — a missing one is the most common setup mistake.

## The script

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
