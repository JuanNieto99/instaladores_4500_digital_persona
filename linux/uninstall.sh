function main(){
    uninstall_sdk
    remove_tmux
}

function uninstall_sdk(){
    cd "/opt/Crossmatch/urusdk-linux"
    sudo ./uninstall

    cd "/opt"
    sudo rm -r Crossmatch

    cd "/etc/ld.so.conf.d"
    sudo rm libfingerprint.conf
} 


function remove_tmux(){
    tmux kill-session -t finger_sesion

    sed -i '/tmux new -d -s finger_sesion -n finger/d' ~/.bashrc

    crontab -l | grep -v "@reboot tmux new -d -s finger_sesion -n finger 'sh /opt/Crossmatch/urusdk-linux/Linux/Samples/finger/execute_fingerprint.sh'" | crontab -
}

main