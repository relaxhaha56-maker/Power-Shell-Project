# --- DEEP INJECTION VERSION (Process Hacker Style) ---
$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    Write-Host "Searching for HD-Player Memory..." -ForegroundColor Cyan
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # Clean and Download
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(500,200)

        Write-Host "Injection Complete! Check F8 in game." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Starting emulator scan and process..." -ForegroundColor White
                    
                    $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
                    if ($Target) {
                        # --- THE CORE CHANGE: FORCE INJECTION VIA SYSTEM CALL ---
                        # ใช้การเรียกผ่าน Namespace เพื่อบังคับให้ System รับรู้การโหลด DLL เข้าไปใน Process ของเกม
                        $ProcID = $Target.Id
                        Write-Host "Target Process ID: $ProcID" -ForegroundColor Gray
                        
                        # สั่งรัน DLL ในรูปแบบปกปิด (Background) เพื่อให้มันเข้าไปฝังตัว
                        Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`",#1" -WindowStyle Hidden
                        
                        Write-Host "114" -ForegroundColor White
                        Write-Host "96" -ForegroundColor White
                        Write-Host "Press F8 again to rescan or close the application to exit." -ForegroundColor White
                        [console]::beep(880,300)
                    } else {
                        Write-Host "Error: HD-Player not found! Please open BlueStacks." -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Error: Access Denied. Please run as Admin!" -ForegroundColor Red
    }
} else {
    Write-Host "Invalid License!" -ForegroundColor Red
}
