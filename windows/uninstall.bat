@echo off

call :main

pause
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


:stop_and_remove_task

    set tasks="RunWSL" "FingerTask"

    for %%t in (%tasks%) do (

        schtasks /query/ tn %%t > nul 2>&1

        if %errorlevel% equ 1 exit

        schtasks /end /tn %%t   
        schtasks /delete /tn %%t /f

        if %errorlevel equ 0 (
            echo La tarea %%t se removió de manera exitosa
        ) else (
            echo Error: No fue posible eliminar la tarea %%t
        )
    )

    exit /b

:remove_finger_files

    set folders="C:\finger" "C:\Users\finger"

    for %%f in (%folders%) do (

        if not exist %%f exit

        rmdir /s /q %%f

        if %errorlevel equ 0 (
            echo el directorio %%f se removió de manera exitosa
        ) else (
            echo Error: No fue posible eliminar el directorio %%f
        )
    )

    exit /b    

:start_process

    call :stop_and_remove_task
    call :remove_finger_files


    exit /b

:main
     title Fingerprint uninstaller - Windows

    call :check_admin adminStatus
    
    if "%adminStatus%"=="0" (call:start_process) else (call:enable_admin)
    exit /b    