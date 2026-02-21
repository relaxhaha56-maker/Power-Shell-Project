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
        
        # ค้นหาตำแหน่งของ HD-Player เพื่อดึง Path มาใช้
        $Proc = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Proc) {
            Write-Host "Syncing with HD-Player..." -ForegroundColor Cyan
            
            # ใช้วิธีเรียกผ่านเครื่องมือระบบโดยไม่ระบุจุดเข้า (Entry Point) เพื่อลดการ Error
            # และใช้คำสั่งรันแบบอำนาจสูงสุด
            $StartInfo = New-Object System.Diagnostics.ProcessStartInfo
            $StartInfo.FileName = "rundll32.exe"
            $StartInfo.Arguments = "`"$DllPath`""
            $StartInfo.Verb = "runas" # บังคับรันด้วยสิทธิ์สูงสุด
            [System.Diagnostics.Process]::Start($StartInfo)
            
            [console]::beep(800,500)
            Write-Host "System Integration Complete!" -ForegroundColor Green
            Write-Host "IMPORTANT: Please press F8 in game lobby." -ForegroundColor Yellow
        } else {
            Write-Host "HD-Player is not running!" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error: Access Denied by Windows." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid HWID!" -ForegroundColor Yellow
}
