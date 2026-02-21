# --- 1. Clean up old sessions ---
Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
$DllPath = "$env:TEMP\gralloc.blue.dll"
if (Test-Path $DllPath) { Remove-Item $DllPath -Force -ErrorAction SilentlyContinue }

# --- 2. License Login ---
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- 3. Validation ---
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
try {
    $Keys = Invoke-RestMethod -Uri $KeyUrl
} catch {
    Write-Host "Server Error: Cannot connect to GitHub" -ForegroundColor Red; pause; exit
}

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "License OK! Downloading components..." -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,200)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            Write-Host "Injecting into HD-Player..." -ForegroundColor Cyan
            
            # Use the most direct way to call the DLL
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`""
            
            [console]::beep(800,400)
            Write-Host "Done! KEEP WINDOW OPEN (MINIMIZE ONLY)." -ForegroundColor Green
            Write-Host "Press F8 in the game Lobby." -ForegroundColor Yellow
            
            # Maintenance loop to keep the DLL active
            while($true) { Start-Sleep -Seconds 10 }
        } else {
            Write-Host "Error: HD-Player not found! Open the game first." -ForegroundColor Red; pause
        }
    } catch {
        Write-Host "Error: Anti-Virus blocked the download!" -ForegroundColor Red; pause
    }
} else {
    Write-Host "Error: Invalid License Key!" -ForegroundColor Red; pause
}
