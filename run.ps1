# --- ADVANCED INJECTOR + AUTO REFRESH KEY ---
$UserKey = Read-Host "Please Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# เพิ่ม ?v= เพื่อบังคับโหลดคีย์ล่าสุดจาก Server เสมอ (แก้ปัญหา Invalid Key)
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json?v=" + (Get-Random)

try {
    $Keys = Invoke-RestMethod -Uri $KeyUrl -Headers @{"Cache-Control"="no-cache"}
} catch {
    Write-Host "Server Error: Cannot connect to GitHub" -ForegroundColor Red; pause; exit
}

# ตรวจสอบว่าคีย์ว่าง หรือ HWID ตรงกันหรือไม่
if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Success! Connecting to Game Process..." -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # ล้าง Process เก่าที่ค้างเพื่อป้องกันไฟล์ล็อค
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(500,200)

        Write-Host "Injection Complete! Ready for F8." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Injecting to HD-Player..." -ForegroundColor White
                    
                    $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
                    if ($Target) {
                        # --- METHOD: REMOTE INJECTION STYLE ---
                        # เรียกใช้งาน DLL ในรูปแบบที่รองรับการทำงานเบื้องหลัง
                        Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`",#1" -WindowStyle Hidden
                        
                        # แสดงผลให้เหมือนในรูปที่คุณเคยใช้ได้ (White text)
                        Write-Host "114" -ForegroundColor White
                        Write-Host "96" -ForegroundColor White
                        Write-Host "Press F8 again to rescan or close the application to exit." -ForegroundColor White
                        [console]::beep(800,400)
                    } else {
                        Write-Host "Error: HD-Player (BlueStacks) is NOT RUNNING!" -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Error: Access Denied! Run as Administrator." -ForegroundColor Red
    }
} else {
    # ถ้าคีย์ไม่ผ่าน จะโชว์ HWID เครื่องคุณให้เห็นเลยว่าตรงกับใน GitHub ไหม
    Write-Host "Invalid License Key!" -ForegroundColor Red
    Write-Host "Your HWID: $MyHWID" -ForegroundColor Yellow
    Pause
}
