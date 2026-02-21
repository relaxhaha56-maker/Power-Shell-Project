$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- Discord Logging ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{
    content = "New Login Attempt - Key: $UserKey - HWID: $MyHWID"
} | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"
# ----------------------

$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if (-not $Keys.PSObject.Properties[$UserKey]) {
    Write-Host "License key error!" -ForegroundColor Red
}
elseif ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    Write-Host "Initializing BasX Aim Lock system..." -ForegroundColor Cyan

    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        
        # ตรวจสอบว่าโปรแกรมจำลอง (HD-Player) เปิดอยู่หรือไม่
        $TargetProcess = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        
        if ($TargetProcess) {
            # ใช้ rundll32 ในการเรียกใช้งาน DLL ร่วมกับ Process เป้าหมาย
            Start-Process -FilePath "rundll32.exe" -ArgumentList "$DllPath,Start HD-Player"
            Write-Host "Successfully injected into HD-Player!" -ForegroundColor Green
            Write-Host "BasX Aim Lock: Active (Press F8 in game)" -ForegroundColor Green
        }
        else {
            # หากไม่เจอ HD-Player จะยังคงลงทะเบียนแบบปกติให้ก่อน
            Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s $DllPath"
            Write-Host "HD-Player not found, running in Standard Mode." -ForegroundColor Yellow
            Write-Host "BasX Aim Lock: Active" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Error: Could not load system files." -ForegroundColor Red
    }
}
else {
    Write-Host "Invalid HWID!" -ForegroundColor Yellow
    Write-Host "Your HWID: $MyHWID" -ForegroundColor Gray
}
