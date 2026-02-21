$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- Discord Logging ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{
    content = "New Login Attempt - Key: $UserKey - HWID: $MyHWID"
} | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# --- Key Validation ---
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if (-not $Keys.PSObject.Properties[$UserKey]) {
    Write-Host "License key error!" -ForegroundColor Red
}
elseif ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,300)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # แก้ไข: ลบ ,DllMain ออกเพื่อให้ Windows หาจุดรันที่ถูกต้องเอง
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`""
            [console]::beep(800,500)
            Write-Host "Injected into HD-Player!" -ForegroundColor Green
        } else {
            Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s `"$DllPath`""
            Write-Host "Standard Mode Active." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error loading DLL." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid HWID!" -ForegroundColor Yellow
}
