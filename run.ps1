# --- Hide PowerShell Window Automatically ---
$showWindow = '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);'
$type = Add-Type -MemberDefinition $showWindow -Name "Win32ShowWindow" -Namespace Win32 -PassThru
$handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle

$UserKey = Read-Host "Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# --- Discord Logging ---
$WebhookUrl = "https://ptb.discord.com/api/webhooks/1474662292846153861/ZDIJqvt5kcgkeOEcPGLIFCzfQkFsVD4lsnKe5rtsOtxFnEarYKMjg_a9s2tJRXjS1o-a"
$LogBody = @{ content = "Login: $UserKey - HWID: $MyHWID" } | ConvertTo-Json
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $LogBody -ContentType "application/json"

# --- Validation ---
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Success! Injecting..." -ForegroundColor Green
    $DllUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll"
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        (New-Object Net.WebClient).DownloadFile($DllUrl, $DllPath)
        [console]::beep(500,300)
        
        $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
        if ($Target) {
            # Start DLL process
            Start-Process -FilePath "rundll32.exe" -ArgumentList "`"$DllPath`""
            [console]::beep(800,500)
            
            Write-Host "Injected! Window will hide in 3 seconds..." -ForegroundColor Cyan
            Start-Sleep -Seconds 3
            
            # Hide the window instead of closing (to keep DLL alive)
            $type::ShowWindow($handle, 0) 
            
            # Background loop
            while ($true) { Start-Sleep -Seconds 10 }
        } else {
            Write-Host "Error: HD-Player not found!" -ForegroundColor Red
            Pause
        }
    } catch {
        Write-Host "Error: Download failed!" -ForegroundColor Red
        Pause
    }
} else {
    Write-Host "Error: Invalid Key!" -ForegroundColor Red
    Pause
}
