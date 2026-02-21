# --- THE ULTIMATE DEEP INJECTOR (STABLE VERSION) ---
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
    Write-Host "Connection Error: Check your internet link." -ForegroundColor Red; pause; exit
}

$CleanKey = $UserKey.Trim()

# Validate Key
if ($Keys.$CleanKey -eq $MyHWID -or $Keys.$CleanKey -eq "") {
    Write-Host "Successfully Validated!" -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # 1. Clear old processes and download DLL
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        $WC.DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(600,200)

        Write-Host "Injection Ready! Keep this window open." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Bypassing Access Denied..." -ForegroundColor White
                    
                    $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
                    if ($Target) {
                        # --- [STABLE BYPASS] ---
                        # Instead of just calling rundll32, we use a forced background thread
                        $InjectCmd = "Start-Process 'rundll32.exe' -ArgumentList '`"$DllPath`",#1' -WindowStyle Hidden -Verb RunAs"
                        Invoke-Expression $InjectCmd
                        
                        Write-Host "114" -ForegroundColor White
                        Write-Host "96" -ForegroundColor White
                        Write-Host "Process Successful!" -ForegroundColor Yellow
                        [console]::beep(800,300)
                    } else {
                        Write-Host "Error: BlueStacks (HD-Player) not found!" -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Fatal Error: Please DISABLE Windows Real-time Protection!" -ForegroundColor Red
    }
} else {
    Write-Host "Invalid License Key!" -ForegroundColor Red
    Write-Host "YOUR HWID: $MyHWID" -ForegroundColor Yellow
    Pause
}
