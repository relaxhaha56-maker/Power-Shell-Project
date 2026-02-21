# ALL ENGLISH - BASIC STABLE VERSION
$UserKey = Read-Host "Please Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Discord Log
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{ content = "User: $UserKey | HWID: $MyHWID" } | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# Key Check
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Success! Connecting to HD-Player..." -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(440,200)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # Use the most basic injection method
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`""
            
            [console]::beep(880,400)
            Write-Host "Injection Done! KEEP THIS WINDOW OPEN." -ForegroundColor Cyan
            Write-Host "Press F8 in Game Lobby." -ForegroundColor Yellow
            
            # Stay alive to prevent DLL unload
            while($true) { Start-Sleep -Seconds 5 }
        } else {
            Write-Host "ERROR: HD-Player not running!" -ForegroundColor Red
            Pause
        }
    } catch {
        Write-Host "ERROR: System Blocked!" -ForegroundColor Red
        Pause
    }
} else {
    Write-Host "ERROR: Invalid Key!" -ForegroundColor Red
    Pause
}
