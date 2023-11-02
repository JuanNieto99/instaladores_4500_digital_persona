 
    # Ruta que deseas en formato Linux
    $rutaEnWSL = "/home/instalacion-sdk-digitalpersona/finger/"

    # Comando que deseas ejecutar en WSL
    $comandoEnWSL = "make && ./finger"  # Reemplaza con el comando que desees ejecutar en WSL

    # Comando para cambiar de directorio y ejecutar el comando en WSL
    $comandoCompleto = "bash -c 'cd $rutaEnWSL && $comandoEnWSL'"

    # Ejecutar WSL y ejecutar el comando
    Start-Process wsl.exe -ArgumentList $comandoCompleto -WindowStyle Hidden

    Start-Process -NoNewWindow wsl.exe 
     
    while ($true) {
 
        # Ejecuta el comando "usbipd wsl list" y almacena el resultado en una variable
        $usbipdResult = Invoke-Expression -Command "usbipd wsl list"

        # Convierte la salida en un array separado por espacio en blanco
        $usbipdArray = $usbipdResult -split '  '

        # Busca la posición si se encuentra la subcadena en algún elemento del array
        foreach ($index in 0..($usbipdArray.Length - 1)) {
            if ($usbipdArray[$index] -like "*4500*Fingerprint*Reader*") {
                $position = $index
                break
            }
        }

        if ($position -ne -1) {  
            
            Invoke-Expression -Command "usbipd wsl attach --busid  $($usbipdArray[  $position -3 ])"
            Write-Host "usbipd wsl attach --busid  $($usbipdArray[  $position -3 ])"

        } else {

            Write-Host "'U.are.U' no se encontró en el array."
        } 

        Start-Sleep -Seconds 5
 
    }
 
 



