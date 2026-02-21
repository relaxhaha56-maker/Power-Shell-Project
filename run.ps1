# --- ADVANCED INJECTOR + ACCESS GRANTED VERSION ---
$UserKey = Read-Host "Please Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# [STRICT] Force a fresh download of the key file
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json?nocache=" + (Get-Random)

try {
    $WC = New-Object System.Net.WebClient
    $WC.Headers.Add("Cache-Control", "no-cache")
    $JsonResponse = $WC.DownloadString($KeyUrl)
    $Keys = $JsonResponse | ConvertFrom-Json
} catch {
    Write-Host "Connection Error: Check your internet or GitHub link." -ForegroundColor Red; pause; exit
}

$CleanKey = $UserKey.Trim()

if ($Keys.$CleanKey -eq $MyHWID -or $Keys.$CleanKey -eq "") {
    Write-Host "Successfully Validated!" -ForegroundColor Green
    Write-Host "Starting Advanced Injection into HD-Player..." -ForegroundColor Cyan
    
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        # Fix: Ensure correct download path
        $WC.DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(600,200)

        Write-Host "Injection Ready! Keep this window open." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Targeting Emulator Memory..." -ForegroundColor White
                    
                    $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
                    if ($Target) {
                        # --- IMPROVED INJECTION: Force Admin Bypass ---
                        $ArgList = "`"$DllPath`",#1"
                        Start-Process "rundll32.exe" -ArgumentList $ArgList -WindowStyle Hidden -Verb RunAs -ErrorAction SilentlyContinue
                        
                        Write-Host "114" -ForegroundColor White
                        Write-Host "96" -ForegroundColor White
                        Write-Host "Done! Press F8 again to re-inject if needed." -ForegroundColor Yellow
                        [console]::beep(800,300)
                    } else {
                        Write-Host "Error: BlueStacks (HD-Player) not found!" -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        # This will now only trigger if the system completely blocks the action
        Write-Host "Injection Failed! Please turn off Virus & threat protection." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid License Key!" -ForegroundColor Red
    Write-Host "-------------------------------------------" -ForegroundColor Gray
    Write-Host "YOUR KEY : $CleanKey" -ForegroundColor White
    Write-Host "YOUR HWID: $MyHWID" -ForegroundColor Yellow
    Write-Host "Copy the Yellow ID above into your keys.json on GitHub." -ForegroundColor Cyan
    Write-Host "-------------------------------------------" -ForegroundColor Gray
    Pause
}
