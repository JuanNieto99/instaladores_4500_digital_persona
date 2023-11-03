para el correcto funcionamiento del sistema debe de ejecutar primero el archivo "install_wsl.bat" dandole dobleclick 

este archivo instalara wsl (Subsistema de Windows para Linux) para poder emular un entorno de linux y poder ejecutar el proyecto, para eso debe tener la virtualizacion de su equipo activa, la cual se activa desde la BIOS de lo contrario este archivo enviara error si este archivo no se completa en su totalidad no se recomienda ejecutar el siguiente archivo, recuerde siempre darle que si a todos los permisos que le pida y estar pendiente a la consola para la confirmacion de instalacion, al finalizar la instalacion correctamente puede pasar 2 cosas 

1 - que aparezca un nueva consola o desde la misma consola pida un usuario y contraseña 

2 - que al finalizar en la consola diga que hay que reiniciar por lo tanto sera necesario reiniciar el equipo para continuar una vez reiniado el equipo aprece una ventana de wsl para que ingresemos el usuario y la contraseña

sugiero usar una contraseña y un usuario facil porque los estaremos usando en el siguiente archivo

y luego ejecuta con doble clieck el archivo "install_service.bat" este instalara el proyecto de linux en ese entorno y crea tareas para que al iniciar windows inicie el proyecto 

tambien instalara softwares adicionales para el correcto funcionamiento de el sistema y la correcta instalacion.

debe de estar pendiente a la consola para dar permisos de admin o permisos al sistema para que continue 

el archivo "finger.ps1" se encarga de inciar el servicio y hacer la conexión de hadwarde entre windows y wsl 

el archivo "RunHidden.vbs" es el que ejecta el administrador de tareas y este a su vez ejecuta "finger.ps1"

