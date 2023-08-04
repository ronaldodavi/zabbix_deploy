#Instalacao do repositorio
apt-get remove zabbix-agent -y
wait
wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1%2Bbionic_all.deb
wait
mkdir /etc/zabbix
dpkg -i zabbix-release_5.0-1%2Bbionic_all.deb
wait
apt-get update
wait
apt-get install zabbix-agent -y
rm -rf /etc/zabbix/zabbix_agentd.conf

#Criacao configucao do arquivo:
#Alterar IP do server e serverActive
echo "
Server=192.168.0.254
ServerActive=192.168.0.254
Hostname=$(hostname)
StartAgents=5
DebugLevel=3
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
Timeout=5
EnableRemoteCommands=1
HostMetadata=linux
" >> /etc/zabbix/zabbix_agentd.conf

#Ativacao do agente
systemctl enable zabbix-agent
systemctl start zabbix-agent
systemctl restart zabbix-agent
systemctl status zabbix-agent
#Liberand porta do agente
iptables -I INPUT  -p tcp --dport 10050 -j ACCEPT

cat /etc/zabbix/zabbix_agentd.conf
