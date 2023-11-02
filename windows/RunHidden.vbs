Set objShell = CreateObject("WScript.Shell")
objShell.Run "PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File ""C:\finger\finger.ps1""", 0, True
