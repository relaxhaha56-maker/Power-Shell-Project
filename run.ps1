$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# IMPORTANT: Change URL below to your RAW keys.json link
$Url = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/main/keys.json"
$Keys = Invoke-RestMethod -Uri $Url

if (-not $Keys.PSObject.Properties[$UserKey]) {
    Write-Host "License key error!" -ForegroundColor Red
}
elseif ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    
    # --- Put your Aim Assist or DLL command here ---
    Write-Host "Loading BasX System..."
}
else {
    Write-Host "Invalid HWID!" -ForegroundColor Yellow
}
