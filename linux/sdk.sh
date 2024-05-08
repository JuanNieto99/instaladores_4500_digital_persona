 
MAINPATH=home
DIRECTORY_SDK='uareu_sdk_v3'

function main(){
    sudo apt update 
    sudo apt upgrade
    
    box_out 'U.are.U® SDK 3.0' 'install'
    check_package "make"
    check_package "gcc"
    
    if get_sdk; then
        install_sdk
    else
        echo "SDK not found"
    fi
}

function check_package(){
    PKG_OK=$(dpkg-query -W --showformat='${Status}' $1|grep "install ok installed")

    echo -e "Checking for $1: $PKG_OK"
    if [ "" = "$PKG_OK" ]; then
    echo -e "No $1. Setting up $1"
    sudo apt-get install $1
    fi
}

function get_sdk(){
    FILE='main.zip'
    DIRECTORY_FILE="/$MAINPATH/$DIRECTORY_SDK/$FILE"

    check_package "wget"
    
    cd "/$MAINPATH"
    mkdir -p $DIRECTORY_SDK 
    
    sudo wget https://github.com/JuanNieto99/instalacion-sdk-digitalpersona/archive/refs/heads/main.zip -P "/$MAINPATH/$DIRECTORY_SDK"
    cd "/$MAINPATH/$DIRECTORY_SDK"

    if [ -f "$FILE" ]; then 
        sudo chmod -R 755 main.zip

        check_package "unzip"
        sudo unzip -o $
        sudo chmod -R 755 instalacion-sdk-digitalpersona
        return 0
    else
        echo "$FILE not found"
        return 1
    fi    
}

function install_sdk(){
    SDK="/$MAINPATH/$DIRECTORY_SDK/instalacion-sdk-digitalpersona-main/sdk/sdk"
    CROSSMATCH="/$MAINPATH/$DIRECTORY_SDK/instalacion-sdk-digitalpersona-main/Crossmatch"

    cd $SDK 
    
    sudo ./install

    copy_files $CROSSMATCH /usr/lib "crossmatch" 
    copy_files /opt/Crossmatch/urusdk-linux/redist/99-dp4k.rules /etc/udev/rules.d "99-dp4k.rules" 
    copy_files /opt/Crossmatch/urusdk-linux/redist/99-dp5k.rules /etc/udev/rules.d "99-dp5k.rules" 
    copy_files /opt/Crossmatch/urusdk-linux/redist/99-touchip.rules /etc/udev/rules.d "99-touchip.rules" 
    
    echo "/usr/lib/Crossmatch/urusdk-linux/Linux/lib/java" | sudo tee -a /etc/ld.so.conf.d/libfingerprint.conf
    echo "/usr/lib/Crossmatch/urusdk-linux/Linux/lib/x64" | sudo tee -a /etc/ld.so.conf.d/libfingerprint.conf
    
    sudo chmod -R 755 /opt/Crossmatch/

    sudo ldconfig

    check_package "libmicrohttpd-dev"
    
    sudo apt install tmux
    
    copi_proyect
    
    remove_files
    
    start_tmux
	
    box_out 'Complete installation'
}

function copy_files(){
    if sudo cp -r $1 $2 
    then 
        echo "$3 successfully copied"
    else
        echo "Failure, exit status $?"
    fi
}

function remove_files(){
    cd "/$MAINPATH"

    sudo rm -r uareu_sdk_v3/
}

function box_out()
{
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w<${#l})) && { b="$l"; w="${#l}"; }
  done
  tput setaf 3
  echo " -${b//?/-}-
| ${b//?/ } |"
  for l in "${s[@]}"; do
    printf '| %s%*s%s |\n' "$(tput setaf 4)" "-$w" "$l" "$(tput setaf 3)"
  done
  echo "| ${b//?/ } |
 -${b//?/-}-"
  tput sgr 0
}

function start_tmux (){
 
  cd /opt/Crossmatch/urusdk-linux/Linux/Samples/finger
  
  sudo chmod +x execute_fingerprint.sh 
  
  tmux new -d -s finger_sesion -n finger 'sh /opt/Crossmatch/urusdk-linux/Linux/Samples/finger/execute_fingerprint.sh'
}

function copi_proyect(){
    
    ruta_a_eliminar="/opt/Crossmatch/urusdk-linux/Linux/Samples/finger"

    # Verificar si la ruta existe
    if [ -d "$ruta_a_eliminar" ]; then
        echo "La ruta existe. Eliminando..."
        # Eliminar la ruta y su contenido recursivamente
        rm -r "$ruta_a_eliminar"
        echo "Ruta eliminada con éxito."
    else
        echo "La ruta no existe, se creara."
    fi
    
    sudo mv "/$MAINPATH/$DIRECTORY_SDK/instalacion-sdk-digitalpersona-main/finger" /opt/Crossmatch/urusdk-linux/Linux/Samples
   
   cd /opt/Crossmatch/urusdk-linux/Linux/Samples
   
   sudo chmod -R 777 finger
   
   cd finger
   
   make
   
   sudo chmod 777 finger
   
   #sudo ./finger
   
}

main

 
