# --- STABLE FORCE INJECTION (ALL ENGLISH) ---
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "License Validated!" -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # FORCE CLEAN: Kill any stuck rundll32 processes
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        Remove-Item $DllPath -Force -ErrorAction SilentlyContinue
        
        # Fresh Download
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
                        # Run DLL in the background (Process Hacker style)
                        Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`"" -WindowStyle Hidden
                        
                        Write-Host "114" -ForegroundColor White
                        Write-Host "96" -ForegroundColor White
                        Write-Host "Press F8 again to rescan..." -ForegroundColor Yellow
                        [console]::beep(800,400)
                    } else {
                        Write-Host "Error: HD-Player (BlueStacks) is not found!" -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Error: Access Denied! Run as Administrator." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid License Key!" -ForegroundColor Red
}
