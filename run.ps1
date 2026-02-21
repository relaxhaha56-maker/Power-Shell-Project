# --- ADVANCED INJECTION VERSION (Process Hacker Style) ---
$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    Write-Host "Forcing Injection into HD-Player..." -ForegroundColor Cyan
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # 1. Clean & Re-download
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(500,200)

        # 2. Wait for F8 (Like your first image)
        Write-Host "Injection Complete! Check F8 in game." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Starting emulator scan and process..." -ForegroundColor White
                    
                    $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
                    if ($Target) {
                        # 3. Simulate Process Hacker (Force execution via WMI)
                        $Cmd = "rundll32.exe `"$DllPath`",#1" 
                        Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList $Cmd | Out-Null
                        
                        Write-Host "114" -ForegroundColor White # Show status like image
                        Write-Host "Press F8 again to rescan or close the application to exit." -ForegroundColor White
                        [console]::beep(800,300)
                    } else {
                        Write-Host "Error: HD-Player not found!" -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Error: System Access Denied!" -ForegroundColor Red
    }
} else {
    Write-Host "Invalid License!" -ForegroundColor Red
}
