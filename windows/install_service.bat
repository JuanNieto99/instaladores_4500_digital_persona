   @echo off
   
   CALL :main

<<<<<<< HEAD
=======
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

    :install_wsl_update
    
        echo Instalando Windows Subsystem for Linux (WSL)...
        echo ---------------------------------------------
 
        echo Descargando wsl_update_x64.msi...
        curl -o wsl_update_x64.msi https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
        echo Instalando wsl_update_x64.msi...
        msiexec /i wsl_update_x64.msi 
 
        winget install --interactive --exact dorssel.usbipd-wi

        :: Habilita WSL 2
        wsl --set-default-version 2 
       
        echo ---------------------------------------------
        :: validar si wsl_update_x64 esta instalado
    EXIT /B

>>>>>>> 6132cbc01fc34af3ec489deb6f38b4a67a962c84
    :startup_files

        echo  Copiando archivos de inicio...
        echo ---------------------------------------------

        set source="C:\Users\finger"
        set programFile="C:\finger"

        if not exist %programFile% mkdir %programFile%

        if not exist %source% mkdir %source%
    
        cd C:\Users\finger
        set carpeta_a_eliminar=C:\Users\finger\instalador-digital-persona

        if exist "%carpeta_a_eliminar%" (
            echo La carpeta existe. Se eliminará.
            rmdir /s /q "%carpeta_a_eliminar%"
            echo Carpeta eliminada con éxito.
                    
            powershell "git clone https://github.com/JuanNieto99/instalador-digital-persona"

        ) else (
             powershell "git clone https://github.com/JuanNieto99/instalador-digital-persona"

        )


        xcopy "%source%\instalador-digital-persona\finger.ps1" "%programFile%" /Y
        xcopy "%source%\instalador-digital-persona\RunHidden.vbs" "%programFile%" /Y
        xcopy "%source%\instalador-digital-persona\RunWSL.ps1" "%programFile%" /Y

       echo ---------------------------------------------
    EXIT /B

    :install_sdk
        echo  Instalado SDK...
        echo ---------------------------------------------
        for /f %%i in ('wsl whoami') do set USERNAME=%%i
        wsl sudo sed -i '/%sudo   ALL=(ALL:ALL) ALL/a %USERNAME% ALL=(ALL:ALL) NOPASSWD: ALL' /etc/sudoers
        powershell "wsl -s Ubuntu-22.04"
        powershell "wsl --update"
        powershell "wsl sudo apt update;"
        powershell "wsl sudo apt install linux-tools-generic hwdata"
        powershell "wsl sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20"
        wsl cd /home ;sudo git clone https://github.com/JuanNieto99/instalador-digital-persona.git 
        powershell "wsl bash /home/instalador-digital-persona/instalacion-sdk-digitalpersona/sdk.sh"
        powershell "wsl bash /home/instalador-digital-persona/instalacion-sdk-digitalpersona/tmux.sh"
        echo ---------------------------------------------
    EXIT /B

    :install_dorssel
        echo  Instalado USBIPD-WIN...
        echo ---------------------------------------------
        usbipd wsl list
        if errorlevel 1 (
            echo El comando retornó un error.
            powershell winget install --interactive --exact dorssel.usbipd-win  
        ) else (
            echo  USBIPD-WIN ya esta instalado 
        )
       
        echo ---------------------------------------------
 
    EXIT /B
  
    :create_task_manger
        echo  Instalado task manager...
        echo ---------------------------------------------

        schtasks /create /tn "FingerTask" /tr "PowerShell.exe -WindowStyle Hidden cd C:\finger ; .\RunHidden.vbs" /sc ONLOGON /RL HIGHEST /F

        schtasks /create /tn "RunWSL" /tr "powershell.exe -WindowStyle Hidden C:\finger\RunWSL.ps1" /sc ONLOGON /RL HIGHEST /F


        set "carpeta_origen=C:\Users\finger\instalador-digital-persona"
        xcopy "%carpeta_origen%\*" "%source%\" /E /I /H /Y

        set "carpeta_a_eliminar=C:\Users\finger\instalador-digital-persona"
        
        rmdir /s /q "%carpeta_a_eliminar%" 
           
        echo ---------------------------------------------

        pause
    EXIT /B

<<<<<<< HEAD
 :main
       
=======

    :start_process
        CALL :install_wsl_update
>>>>>>> 6132cbc01fc34af3ec489deb6f38b4a67a962c84
        CALL :startup_files
        CALL :install_sdk
        CALL :install_dorssel
        CALL :create_task_manger 
        exit /b


    :main
        
        title Fingerprint installer - Windows

        call :check_admin adminStatus
    
        if "%adminStatus%"=="0" (call:start_process) else (call:enable_admin)    
 exit /b