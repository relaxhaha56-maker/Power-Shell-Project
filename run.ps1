$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- Discord Logging ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{
    content = "Final Independent Injection - Key: $UserKey"
} | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# --- Key Validation ---
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully! Deploying Independent Process..." -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,300)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # ใช้ WMI เพื่อสร้าง Process ที่ไม่ขึ้นตรงกับ PowerShell
            $Command = "rundll32.exe `"$DllPath`""
            Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList $Command | Out-Null
            
            [console]::beep(800,500)
            Write-Host "Injected Independently! Closing PowerShell in 3s..." -ForegroundColor Cyan
            Start-Sleep -Seconds 3
            exit
        } else {
            Write-Host "Open BlueStacks (HD-Player) first!" -ForegroundColor Red
            Pause
        }
    } catch {
        Write-Host "Error: Access Denied." -ForegroundColor Red
        Pause
    }
} else {
    Write-Host "Invalid Key!" -ForegroundColor Red
    Pause
}
