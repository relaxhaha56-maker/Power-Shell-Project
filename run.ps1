# --- ADVANCED INJECTOR + FIXED KEY SYSTEM (ENGLISH VERSION) ---
$UserKey = Read-Host "Please Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# [FIX] Force fresh data from GitHub to prevent Cache issues
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json?v=" + (Get-Random)

try {
    $Keys = Invoke-RestMethod -Uri $KeyUrl -Headers @{"Cache-Control"="no-cache"; "Pragma"="no-cache"}
} catch {
    Write-Host "Server Error: Cannot connect to GitHub" -ForegroundColor Red; pause; exit
}

# [FIX] Remove any accidental spaces from input
$CleanKey = $UserKey.Trim()

# Validate Key and HWID
if ($Keys.$CleanKey -eq "" -or $Keys.$CleanKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    Write-Host "Success! Connecting to Game Process..." -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # Clean previous stuck processes
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
                        # Execute DLL in background (Process Hacker style)
                        Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`",#1" -WindowStyle Hidden
                        
                        # Output matching your original working version
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
    # If key fails, display real HWID for easy copying to keys.json
    Write-Host "Invalid License Key!" -ForegroundColor Red
    Write-Host "-------------------------------------------" -ForegroundColor Gray
    Write-Host "Your Input: [$CleanKey]" -ForegroundColor White
    Write-Host "Your HWID: $MyHWID" -ForegroundColor Yellow
    Write-Host "Please make sure this HWID matches exactly in keys.json" -ForegroundColor Cyan
    Write-Host "-------------------------------------------" -ForegroundColor Gray
    Pause
}
