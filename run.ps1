# --- RE-INJECTION STABLE VERSION ---
$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Validated! System Ready." -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # Initial Download
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(500,200)
        
        Write-Host "Injection Complete! Check F8 in game." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    # FORCE CLEAN BEFORE START
                    Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
                    Start-Sleep -Milliseconds 500
                    
                    Write-Host "F8 pressed! Re-scanning emulator..." -ForegroundColor White
                    Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`"" -WindowStyle Hidden
                    
                    Write-Host "114" -ForegroundColor White
                    Write-Host "96" -ForegroundColor White
                    Write-Host "Press F8 again to rescan..." -ForegroundColor White
                    [console]::beep(800,300)
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Error: Access Denied!" -ForegroundColor Red
    }
} else {
    Write-Host "Invalid Key!" -ForegroundColor Red
}
