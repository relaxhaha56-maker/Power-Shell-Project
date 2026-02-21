# English Version - Stable Manual Injection
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- Discord Logging ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{ content = "Login Attempt: $UserKey - HWID: $MyHWID" } | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# --- Key Validation ---
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "License Validated!" -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # Clean old file before download
        Remove-Item $DllPath -Force -ErrorAction SilentlyContinue
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,300)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # Standard execution (Most Stable)
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`""
            
            [console]::beep(800,500)
            Write-Host "Injection Complete!" -ForegroundColor Cyan
            Write-Host "KEEP THIS WINDOW OPEN (MINIMIZE ONLY)" -ForegroundColor Yellow
            
            # Keep process alive to support the DLL
            while ($true) { Start-Sleep -Seconds 10 }
        } else {
            Write-Host "Error: HD-Player not found. Please open the game!" -ForegroundColor Red
            Pause
        }
    } catch {
        Write-Host "Error: Failed to process DLL." -ForegroundColor Red
        Pause
    }
} else {
    Write-Host "Error: Invalid License Key!" -ForegroundColor Red
    Pause
}
