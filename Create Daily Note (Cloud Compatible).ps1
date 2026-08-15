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
