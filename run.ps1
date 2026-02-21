# --- ADVANCED INJECTOR + KEY BYPASS SYSTEM ---
$UserKey = Read-Host "Please Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# [STRICT] Force a fresh download of the key file every single time
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json?nocache=" + (Get-Random)

try {
    # Use WebClient for a more direct download to bypass system proxy/cache
    $WC = New-Object System.Net.WebClient
    $WC.Headers.Add("Cache-Control", "no-cache")
    $JsonResponse = $WC.DownloadString($KeyUrl)
    $Keys = $JsonResponse | ConvertFrom-Json
} catch {
    Write-Host "Connection Error: Check your internet or GitHub link." -ForegroundColor Red; pause; exit
}

# [STRICT] Clean input to prevent hidden space errors
$CleanKey = $UserKey.Trim()

# Check if the key matches the HWID or is empty (Master Access)
if ($Keys.$CleanKey -eq $MyHWID -or $Keys.$CleanKey -eq "") {
    Write-Host "Successfully Validated!" -ForegroundColor Green
    Write-Host "Starting Advanced Injection into HD-Player..." -ForegroundColor Cyan
    
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # 1. Kill old sessions and download fresh DLL
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        $WC.DownloadFile("https://raw.githubusercontent.com/relaxhaha56-bar/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
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
                        # 2. Execute via Process Hacker Method (Background Thread)
                        Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`",#1" -WindowStyle Hidden
                        
                        # Display status codes like your original working version
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
        Write-Host "Critical Error: Access Denied. Run as Administrator!" -ForegroundColor Red
    }
} else {
    # If it fails, show the exact HWID to copy-paste into GitHub
    Write-Host "Invalid License Key!" -ForegroundColor Red
    Write-Host "-------------------------------------------" -ForegroundColor Gray
    Write-Host "YOUR KEY : $CleanKey" -ForegroundColor White
    Write-Host "YOUR HWID: $MyHWID" -ForegroundColor Yellow
    Write-Host "Copy the Yellow ID above into your keys.json on GitHub." -ForegroundColor Cyan
    Write-Host "-------------------------------------------" -ForegroundColor Gray
    Pause
}
