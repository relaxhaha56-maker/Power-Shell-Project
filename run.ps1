$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# 1. Database Connection
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if (-not $Keys.PSObject.Properties[$UserKey]) {
    Write-Host "License key error!" -ForegroundColor Red
}
elseif ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    Write-Host "Initializing BasX Aim Lock system..." -ForegroundColor Cyan

    # 2. Download and Execute DLL
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        # Change 'regsvr32.exe' to your specific injector if needed
        Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s $DllPath"
        Write-Host "BasX Aim Lock: Active" -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Could not load system files." -ForegroundColor Red
    }
}
else {
    Write-Host "Invalid HWID!" -ForegroundColor Yellow
}
