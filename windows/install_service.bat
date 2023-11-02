   
   
    echo Instalando Windows Subsystem for Linux (WSL)...
    echo ---------------------------------------------

    :: Habilita la característica de WSL
    :: wsl --install

    :: Descargar e instalar el paquete de actualización de WSL
    echo Descargando wsl_update_x64.msi...
    curl -o wsl_update_x64.msi https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
    echo Instalando wsl_update_x64.msi...
    msiexec /i wsl_update_x64.msi



    :: Habilita WSL 2
    wsl --set-default-version 2 

    echo ---------------------------------------------
    echo Instalación completa. Reinicia tu sistema para aplicar los cambios.

set "archivo=Path\to\wsl_update_x64.msi"

if exist "%archivo%" (
    echo El archivo wsl_update_x64.msi está instalado.
) else (
    echo El archivo wsl_update_x64.msi no está instalado.
)

    set source="C:\Users\finger"
    set destination="\\wsl.localhost\Ubuntu\home\instalacion-sdk-digitalpersona"
    set programFile="C:\finger"

    if not exist %programFile% mkdir %programFile%

    if not exist %source% mkdir %source%
 
 
    cd C:\Users\finger

    powershell "git clone https://github.com/JuanNieto99/instalador-digital-persona"

    xcopy "%source%\instalador-digital-persona\finger.ps1" "%programFile%" /Y
    xcopy "%source%\instalador-digital-persona\RunHidden.vbs" "%programFile%" /Y


    wsl sudo sed -i '/%sudo   ALL=(ALL:ALL) ALL/a pc ALL=(ALL:ALL) NOPASSWD: ALL' /etc/sudoers

   : powershell "wsl sudo killall apt apt-get"
    powershell "wsl -s Ubuntu-22.04"
    powershell "wsl --update"
    powershell "wsl sudo apt update;"
    powershell "wsl sudo apt install linux-tools-generic hwdata"
    powershell "wsl sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20"
    wsl cd /home ;sudo git clone https://github.com/JuanNieto99/instalador-digital-persona.git 
   : powershell "wsl sudo git clone https://github.com/JuanNieto99/instalador-digital-persona.git"
    
    powershell "wsl bash /home/instalador-digital-persona/instalacion-sdk-digitalpersona/sdk.sh"
    powershell "wsl bash /home/instalador-digital-persona/instalacion-sdk-digitalpersona/tmux.sh"

    powershell winget install --interactive --exact dorssel.usbipd-win   

    schtasks /create /tn "FingerTask" /tr "PowerShell.exe cd C:\finger ; .\RunHidden.vbs" /sc ONLOGON /RL HIGHEST /F
    schtasks /create /tn "RunWSL" /tr "powershell.exe -File C:\finger\RunWSL.ps1" /sc ONLOGON /RL HIGHEST /F
 
    rem Pausa para que puedas ver los resultados antes de que se cierre la ventana

    set "carpeta_origen=C:\Users\finger\instalador-digital-persona"
    xcopy "%carpeta_origen%\*" "%source%\" /E /I /H /Y

    set "carpeta_a_eliminar=C:\Users\finger\instalador-digital-persona"
    
    rmdir /s /q "%carpeta_a_eliminar%" 
   
    pause
     