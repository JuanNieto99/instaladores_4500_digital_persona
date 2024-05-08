# Define la línea que deseas agregar al archivo crontab
cron_line="@reboot tmux new -d -s finger_sesion -n finger 'sh /opt/Crossmatch/urusdk-linux/Linux/Samples/finger/execute_fingerprint.sh'"

# Agrega la línea al archivo crontab
(crontab -l; echo "$cron_line") | crontab -

echo "Comando agregado al cron."
 
 # Define la línea que deseas agregar al archivo ~/.bashrc
bashrc_line="tmux new -d -s finger_sesion -n finger 'sh /opt/Crossmatch/urusdk-linux/Linux/Samples/finger/execute_fingerprint.sh'"

# Agrega la línea al archivo ~/.bashrc
echo "$bashrc_line" >> ~/.bashrc

echo "Comando agregado a ~/.bashrc."

sleep 2

#gnome-terminal

sleep 2

gnome-terminal -- bash -c "exit"
