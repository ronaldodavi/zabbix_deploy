#!/bin/bash
#Para RockeLinux 8
# zabbix agent 6
#Remocao zabbix antigo se houver


sudo dnf -y remove zabbix*
wait
#Instalacao do repositorio

sudo dnf install https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-4.el8.noarch.rpm -y
wait
#Instalacao do agente zabbix

sudo dnf install -y zabbix-agent
wait
#Backup do arquivo original

mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.orig

#Criacao configucao do arquivo:
#Alterar IP do server e serverActive
echo "

Server=10.100.0.254
ServerActive=10.100.0.254
Hostname=SEFIN-CAUCAIA-LNX-AD1
StartAgents=5
DebugLevel=3
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
Timeout=5
EnableRemoteCommands=1
HostMetadata=linux

" >> /etc/zabbix/zabbix_agentd.conf

#Ativacao do agente
systemctl enable zabbix-agent && systemctl start zabbix-agent && systemctl status zabbix-agent
#Liberand porta do agente
iptables -A INPUT -p tcp -s 10.100.0.254 --dport 10050 -m state --state NEW,ESTABLISHED -j ACCEPT

cat /etc/zabbix/zabbix_agentd.conf


