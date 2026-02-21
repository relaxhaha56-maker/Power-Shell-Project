$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- ระบบส่ง Log เข้า Discord ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474652149328904202/5fJKJNDq-idufG0rJsCiuYqbPfaSmVVSurn7d0vJN9fi7f2PrPiSflrT8AaHWFTJC3XC"
$LogBody = @{
    content = "🚀 **มีคนพยายามเข้าใช้งาน!**`n🔑 **Key:** $UserKey`n🆔 **HWID:** $MyHWID"
} | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"
# ------------------------------

$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if (-not $Keys.PSObject.Properties[$UserKey]) {
    Write-Host "License key error!" -ForegroundColor Red
}
elseif ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    Write-Host "Initializing BasX Aim Lock system..." -ForegroundColor Cyan

    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s $DllPath"
        Write-Host "BasX Aim Lock: Active" -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Could not load system files." -ForegroundColor Red
    }
}
else {
    Write-Host "Invalid HWID!" -ForegroundColor Yellow
    Write-Host "Your HWID: $MyHWID" -ForegroundColor Gray
}
