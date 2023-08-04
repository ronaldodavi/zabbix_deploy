#!/bin/bash
#Para Centos
#Remocao zabbix antigo se houver


yum -y remove zabbix*
wait
#Instalacao do repositorio

rpm -ivh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
wait
#Instalacao do agente zabbix

yum install zabbix-agent -y
wait
#Backup do arquivo original

mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.orig

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
systemctl enable zabbix-agent && systemctl start zabbix-agent && systemctl status zabbix-agent
#Liberand porta do agente
iptables -A INPUT -p tcp -s 192.168.0.254 --dport 10050 -m state --state NEW,ESTABLISHED -j ACCEPT

cat /etc/zabbix/zabbix_agentd.conf
