$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- Discord Logging ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{
    content = "Background Injection Attempt - Key: $UserKey"
} | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# --- Key Validation ---
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully! Starting background process..." -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,300)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # ใช้คำสั่ง Start-Process แบบไม่สร้างหน้าต่างใหม่ และแยกตัวออกมาเป็นอิสระ
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`"" -WindowStyle Hidden
            
            [console]::beep(800,500)
            Write-Host "Injected! You can close this window now." -ForegroundColor Cyan
            Start-Sleep -Seconds 2
            exit # ปิดตัวเองอัตโนมัติ
        } else {
            Write-Host "Please open HD-Player first!" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error loading files." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid License!" -ForegroundColor Red
}
