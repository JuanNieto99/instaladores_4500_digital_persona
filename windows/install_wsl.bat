@echo off

   
setlocal enabledelayedexpansion

REM Ejecuta un comando WMIC para obtener información sobre la virtualización AMD-V
for /f "tokens=*" %%a in ('wmic cpu get VirtualizationFirmwareEnabled') do (
  set "line=%%a"
  if "!line!"=="TRUE" (
    echo La virtualización AMD-V está habilitada en este sistema. 
  ) else if "!line!"=="FALSE" (
    echo La virtualización AMD-V no está habilitada en este sistema.
  )
)

endlocal

systeminfo | findstr /C:"Hyper-V" > NUL
if %errorlevel%==0 (
    echo Virtualización habilitada.
  
) else (
    echo Virtualización no habilitada.
)

CALL :main

pause

pause >nul
exit /b

:enable_admin
    NET FILE 1>NUL 2>NUL || (
        powershell -Command "Start-Process -Verb RunAs -FilePath '%~dpnx0' -ArgumentList 'am_admin'"

        EXIT
    )
    EXIT /B


EXIT /B


:check_Admin
    
    net session >nul 2>&1
    set adminStatus=%errorlevel%

EXIT /B


:enable_windows_features
    powershell dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    powershell dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    powershell Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    powershell Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-All" -NoRestart
    powershell Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

exit /B


:install_wsl

    echo "Al finalzar la instalacion reinicia el computador"
    powershell "wsl --install -d Ubuntu-22.04 "
    powershell "wsl -s Ubuntu-22.04"
    powershell "wsl --update"
    
EXIT /B 

:install_git

    git --version > nul 2>&1
    if %errorlevel% equ 0 (
        echo Git está instalado en tu sistema.
    ) else (
        echo Git no está instalado lo instalaremos.
        winget install --id Git.Git -e --source winget
    )
   
EXIT /B
  
:install_winget

    where winget > nul 2>&1

    if %errorlevel% == 0 (
        echo winget está instalado en este sistema.
    ) else (
        start "Microsoft Store" "ms-windows-store://pdp?ProductId=9NBLGGH4NNS1"  
        echo winget no está instalado en este sistema, se abrira la tienda para que se instale.
    )
 
EXIT /B

:restart
    echo es necesario reiniciar para que los cambios se efectuen

    : shutdown /r /t 0
EXIT /B

:main
        CALL :install_winget
        CALL :check_Admin 
        CALL :enable_admin
        CALL :enable_windows_features 
        CALL :install_git
        CALL :install_wsl
        CALL :restart 
exit /b