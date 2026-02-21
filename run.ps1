# --- STABLE INJECTION VERSION ---
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Success!" -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(500,200)

        Write-Host "Injection Complete! Check F8 in game." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Starting emulator scan..." -ForegroundColor White
                    
                    # บังคับฉีดโดยใช้ความล่าช้าเล็กน้อยเพื่อให้ Memory นิ่ง
                    Start-Sleep -Milliseconds 200
                    Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`",#1" -WindowStyle Hidden
                    
                    Write-Host "114" -ForegroundColor White
                    Write-Host "96" -ForegroundColor White
                    Write-Host "Press F8 again to rescan..." -ForegroundColor Yellow
                    [console]::beep(800,300)
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Error: Access Denied! Please run as Admin." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid Key!" -ForegroundColor Red
}
