@echo off

set "enabledCount=0"   
setlocal enabledelayedexpansion
echo  virtualizacion...
echo ---------------------------------------------
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
echo ---------------------------------------------

CALL :main

pause

pause >nul
exit /b

:check_admin
    net session >nul 2>&1
    set adminStatus=%errorlevel%
    
    exit /B

:enable_admin
    set /p answer=Para continuar debe Habilitar permisos de administrador ¿Desea continuar? (y/n): 
    
    if /i "%answer%"=="y" (
        NET FILE 1>NUL 2>NUL || (
            powershell -Command "Start-Process -Verb RunAs -FilePath '%~dpnx0' -ArgumentList 'am_admin'"
            exit
        )
    ) else if /i "%answer%"=="n" (
            echo No se han asignados privilegios de administrador.
            echo El terminal se cerrará en 5 segundos. Pulse cualquier tecla para cerrarlo inmediatamente.
            timeout /nobreak /t 5 >nul
            choice /n /c Y /t 0 /d Y >nul
        exit
    ) 

    exit /b


:enable_windows_features
    set features=VirtualMachinePlatform Microsoft-Windows-Subsystem-Linux "Microsoft-Hyper-V-All"

    for %%f in (%features%) do call :is_windows_featureEnabled %%f

    exit /b


:is_windows_featureEnabled
    set "featureName=%1"
    set "isEnabled=false"

    powershell -Command "& {if(Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq '%featureName%' -and $_.State -eq 'Enabled' }) { exit 0 } else { exit 1 }}"

    if %errorlevel% equ 0 (
        echo %featureName% esta habilitada.
    ) else (
        echo %featureName% no esta habilitada. Habilitando...
        call :enable_feature %featureName%
    )

    exit /b

:enable_feature
    set "featureName=%1"
    powershell Enable-WindowsOptionalFeature -Online -FeatureName %featureName% -NoRestart
    
    if !errorlevel! equ 0 (
        echo %featureName% ha sido habilitada.
        set /a enabledCount+=1
    ) else (
        echo Fallo al habilitar %featureName%.
    )

    exit /b



:install_wsl
    echo  instalado wsl...
    echo ---------------------------------------------

    echo "Al finalzar la instalacion reinicia el computador"
    powershell "wsl --install -d Ubuntu-22.04 "
    powershell "wsl -s Ubuntu-22.04"
    powershell "wsl --update"
    echo ---------------------------------------------

EXIT /B 

:install_git

    git --version > nul 2>&1
    if %errorlevel% equ 0 (
        echo Git está instalado en tu sistema.
    ) else (
        echo Git no está instalado lo instalaremos.
        echo  instalado git...
        echo ---------------------------------------------
        winget install --id Git.Git -e --source winget
        echo ---------------------------------------------

    )
   
EXIT /B
  
:install_winget

    where winget > nul 2>&1

    if %errorlevel% == 0 (
        echo winget está instalado en este sistema.
    ) else (
        echo  instalado winget...
        echo ---------------------------------------------
        start "Microsoft Store" "ms-windows-store://pdp?ProductId=9NBLGGH4NNS1"  
        echo winget no está instalado en este sistema, se abrira la tienda para que se instale.
        echo ---------------------------------------------

    )
 
EXIT /B

:restart
    echo es necesario reiniciar para que los cambios se efectuen

    : shutdown /r /t 0
EXIT /B


:start_process
    CALL :install_winget
    CALL :enable_windows_features 
    CALL :install_git
    CALL :install_wsl
    CALL :restart
    exit /b


:main
    title Fingerprint installer - Windows

    call :check_admin adminStatus
    
    if "%adminStatus%"=="0" (call:start_process) else (call:enable_admin)
 
exit /b