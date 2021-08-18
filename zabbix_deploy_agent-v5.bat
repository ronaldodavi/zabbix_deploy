@echo off
net stop "zabbix agent"

c:\zabbix\zabbix_agentd.exe --uninstall
cd c:\
rd /s /Q zabbix

echo Cria diretoria na unidade C:
mkdir c:\zabbix
mkdir c:\zabbix\dev
echo Pasta zabbix criada no C:

bitsadmin /transfer zagt /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v5/zabbix_agentd.exe c:\zabbix\zabbix_agentd.exe
bitsadmin /transfer zget /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v5/zabbix_get.exe c:\zabbix\zabbix_get.exe
bitsadmin /transfer zgsed /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v5/zabbix_sender.exe c:\zabbix\zabbix_sender.exe
bitsadmin /transfer zdll /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v5/dev/zabbix_sender.dll c:\zabbix\dev\zabbix_sender.dll

echo Server=192.168.0.254 >> c:\zabbix\zabbix_agentd.conf
echo ServerActive=192.168.0.254 >> c:\zabbix\zabbix_agentd.conf
echo Hostname=%COMPUTERNAME% >> c:\zabbix\zabbix_agentd.conf
echo StartAgents=5 >> c:\zabbix\zabbix_agentd.conf
echo DebugLevel=3 >> c:\zabbix\zabbix_agentd.conf
echo LogFile=c:\zabbix\zabbix_agentd.log >> c:\zabbix\zabbix_agentd.conf
echo Timeout=5 >> c:\zabbix\zabbix_agentd.conf
echo EnableRemoteCommands=1 >> C:\zabbix\zabbix_agentd.conf
echo HostMetadata=windows >> C:\zabbix\zabbix_agentd.conf

C:\zabbix\zabbix_agentd.exe -i -c C:\zabbix\zabbix_agentd.conf
C:\zabbix\zabbix_agentd.exe -s -c C:\zabbix\zabbix_agentd.conf
net start "zabbix agent"
net restart "zabbix agent"
echo As configuracoes para o servidor >> c:\zabbix\inst_agent.log
echo %COMPUTERNAME% foram criadas em %date% as %time% >> c:\zabbix\inst_agent.log
