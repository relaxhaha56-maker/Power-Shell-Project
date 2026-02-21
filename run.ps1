# English version - Full Overwrite
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Discord Logging
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{ content = "Final Attempt: $UserKey" } | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# Key Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Validated! System starting..." -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,300)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # --- THE TRICK: Run via Explorer to detach from PowerShell ---
            $Command = "rundll32.exe `"$DllPath`""
            Start-Process "explorer.exe" -ArgumentList $Command
            
            [console]::beep(800,500)
            Write-Host "Injection Successful!" -ForegroundColor Cyan
            Write-Host "The menu will appear in-game. Closing this window..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            exit
        } else {
            Write-Host "Error: Please open BlueStacks first!" -ForegroundColor Red
            Pause
        }
    } catch {
        Write-Host "System Error!" -ForegroundColor Red
        Pause
    }
} else {
    Write-Host "Invalid Key!" -ForegroundColor Red
    Pause
}
