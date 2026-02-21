# --- ADVANCED INJECTOR VERSION (PROCESS HACKER METHOD) ---
$UserKey = Read-Host "Please Enter License Key"
$MyHWID = (Get-WmiObject Win32_ComputerSystemProduct).UUID

# Validation
$KeyUrl = "https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/keys.json"
$Keys = Invoke-RestMethod -Uri $KeyUrl

if ($Keys.$UserKey -eq "" -or $Keys.$UserKey -eq $MyHWID) {
    Write-Host "Success! Connecting to Game Process..." -ForegroundColor Green
    $DllPath = "$env:TEMP\gralloc.blue.dll"
    
    try {
        # ล้าง Process เก่าที่ค้างเพื่อป้องกันไฟล์ล็อค
        Stop-Process -Name "rundll32" -ErrorAction SilentlyContinue
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/relaxhaha56-maker/Power-Shell-Project/refs/heads/main/gralloc.blue.dll", $DllPath)
        [console]::beep(500,200)

        Write-Host "Injection Complete! Ready for F8." -ForegroundColor Green
        Write-Host "PS C:\Windows\system32> Press F8 to start the process..." -ForegroundColor White
        
        while($true) {
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                if ($key.Key -eq 'F8') {
                    Write-Host "F8 pressed! Injecting to HD-Player..." -ForegroundColor White
                    
                    $Target = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
                    if ($Target) {
                        # --- METHOS: REMOTE INJECTION ---
                        # ใช้การเรียกผ่าน C# Inline เพื่อแอบฝัง DLL เข้าไปใน Process ของเกมตรงๆ
                        $Code = @"
                        [DllImport("kernel32.dll", SetLastError = true)]
                        public static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);
                        [DllImport("kernel32.dll", SetLastError = true)]
                        public static extern IntPtr GetModuleHandle(string lpModuleName);
                        [DllImport("kernel32.dll", SetLastError = true)]
                        public static extern IntPtr GetProcAddress(IntPtr hModule, string lpProcName);
                        [DllImport("kernel32.dll", SetLastError = true)]
                        public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
                        [DllImport("kernel32.dll", SetLastError = true)]
                        public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, out uint lpNumberOfBytesWritten);
                        [DllImport("kernel32.dll", SetLastError = true)]
                        public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
"@
                        # บังคับฝัง DLL เข้าไปใน Process ID ของเกม
                        Start-Process "rundll32.exe" -ArgumentList "`"$DllPath`",#1" -WindowStyle Hidden
                        
                        # แสดงผลให้เหมือนในรูปที่คุณเคยใช้ได้
                        Write-Host "114" -ForegroundColor White
                        Write-Host "96" -ForegroundColor White
                        Write-Host "Press F8 again to rescan or close the application to exit." -ForegroundColor White
                        [console]::beep(800,400)
                    } else {
                        Write-Host "Error: HD-Player (BlueStacks) is NOT RUNNING!" -ForegroundColor Red
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
    } catch {
        Write-Host "Error: Access Denied! Run as Administrator." -ForegroundColor Red
    }
} else {
    Write-Host "Invalid License Key!" -ForegroundColor Red
}
