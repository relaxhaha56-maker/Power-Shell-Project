# COMPLETE OVERWRITE - STABLE VERSION
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Log
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{ content = "Final Login Attempt: $UserKey" } | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Validated! System starting..." -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(440,300)
        Start-Sleep -Seconds 2 # Wait for system to recognize file
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # Start the DLL and keep it attached
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`""
            
            [console]::beep(880,500)
            Write-Host "Injection Ready! KEEP THIS WINDOW OPEN (MINIMIZE)." -ForegroundColor Cyan
            Write-Host "If F8 doesn't work, please restart BlueStacks." -ForegroundColor Yellow
            
            # Vital Loop - Do not close
            while ($true) { Start-Sleep -Seconds 5 }
        } else {
            Write-Host "Error: HD-Player not found!" -ForegroundColor Red; pause
        }
    } catch {
        Write-Host "Error: System blocked the file!" -ForegroundColor Red; pause
    }
} else {
    Write-Host "Error: Invalid Key!" -ForegroundColor Red; pause
}
