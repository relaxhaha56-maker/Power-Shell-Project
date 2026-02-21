$UserKey = Read-Host "Please enter your License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- Discord Logging ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{
    content = "New Login Attempt - Key: $UserKey - HWID: $MyHWID"
} | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# --- Key Validation ---
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if (-not $Keys.PSObject.Properties[$UserKey]) {
    Write-Host "License key error!" -ForegroundColor Red
}
elseif ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Successfully!" -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,300)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            Write-Host "Forcing Injection into HD-Player..." -ForegroundColor Cyan
            
            # ใช้การโหลด Library เข้าสู่ระบบโดยตรง (วิธีที่ใกล้เคียงกับ Process Hacker ที่สุดใน PowerShell)
            $Source = @"
            using System;
            using System.Runtime.InteropServices;
            public class Injector {
                [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
                public static extern IntPtr LoadLibrary(string lpFileName);
            }
"@
            Add-Type -TypeDefinition $Source
            [Injector]::LoadLibrary($DllPath)
            
            [console]::beep(800,500)
            Write-Host "Injection Complete! Check F8 in game." -ForegroundColor Green
        } else {
            Write-Host "HD-Player NOT FOUND. Open your emulator first!" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error: System protection blocked the injection." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid HWID!" -ForegroundColor Yellow
}
