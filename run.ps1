# --- STABLE VERSION: KEEP WINDOW OPEN ---
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Discord Logging
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{ content = "Stable Login: $UserKey" } | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# Key Validation
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
            # Start the DLL process directly
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`""
            
            [console]::beep(800,500)
            Write-Host "------------------------------------------" -ForegroundColor Cyan
            Write-Host "STATUS: ACTIVE (Injection Complete)" -ForegroundColor Green
            Write-Host "INSTRUCTION: DO NOT CLOSE THIS WINDOW!" -ForegroundColor Red
            Write-Host "MINIMIZE THIS WINDOW AND PRESS F8 IN GAME." -ForegroundColor Yellow
            Write-Host "------------------------------------------" -ForegroundColor Cyan
            
            # This loop keeps PowerShell active to support the DLL
            while ($true) { Start-Sleep -Seconds 10 }
        } else {
            Write-Host "Error: HD-Player not found! Please open BlueStacks." -ForegroundColor Red
            Pause
        }
    } catch {
        Write-Host "Error: System blocked the download or injection." -ForegroundColor Red
        Pause
    }
} else {
    Write-Host "Error: Invalid Key!" -ForegroundColor Red
    Pause
}
