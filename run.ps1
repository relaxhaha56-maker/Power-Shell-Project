# --- VERSION 1: INTERNAL F8 HANDLER (LIKE ORIGINAL) ---
$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    Write-Host "Forcing Injection into HD-Player..." -ForegroundColor Cyan
    [console]::beep(500,300)
    
    # Loop for F8 Detection (Same as your first image)
    Write-Host "Injection Complete! Check F8 in game." -ForegroundColor Green
    Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
    
    while($true) {
        # จำลองการทำงานแบบเดิมที่รอรับค่า F8
        if ([console]::KeyAvailable) {
            $key = [console]::ReadKey($true)
            if ($key.Key -eq 'F8') {
                Write-Host "F8 pressed! Starting emulator scan and process..." -ForegroundColor White
                [console]::beep(800,200)
                # ส่วนนี้คือจุดที่ DLL จะทำงานร่วมกับเกม
                Start-Process "rundll32.exe" -ArgumentList "`"$env:TEMP\gralloc.blue.dll`"" -WindowStyle Hidden
                Write-Host "96" -ForegroundColor White
                Write-Host "Press F8 again to rescan or close the application to exit." -ForegroundColor White
            }
        }
        Start-Sleep -Milliseconds 100
    }
} else {
    Write-Host "Invalid License!" -ForegroundColor Red
    Pause
}
