@echo off
rem Necessario para instalar o serviço do zabbix alterar dominio ou colocar usuario com privilegios de administrador.
runas /user:administrator

IF EXIST "c:\Zabbix\zabbix_agentd.exe" (exit) ELSE (echo "Iniciando a instalacao do Zabbix Agent")

echo Exibe mensagem na tela
echo Copiando Arquivos

echo Cria diretoria na unidade C:
mkdir c:\zabbix
echo Pasta zabbix criada no C:


bitsadmin /transfer zconf /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/zabbix_agentd.conf c:\zabbix\zabbix_agentd.conf
bitsadmin /transfer zagt /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/zabbix_agentd.exe c:\zabbix\zabbix_agentd.exe
bitsadmin /transfer zget /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/zabbix_get.exe c:\zabbix\zabbix_get.exe
bitsadmin /transfer zgsed /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/zabbix_sender.exe c:\zabbix\zabbix_sender.exe
bitsadmin /transfer zdll /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/dev/zabbix_sender.dll c:\zabbix\dev\zabbix_sender.dll

 
echo Criando Arquivos de configuracao

echo Server=192.168.0.254 > c:\zabbix\zabbix_agentd.conf
echo Hostname=%COMPUTERNAME% >> c:\zabbix\zabbix_agentd.conf
echo StartAgents=5 >> c:\zabbix\zabbix_agentd.conf
echo DebugLevel=3 >> c:\zabbix\zabbix_agentd.conf
echo LogFile=c:\zabbix\zabbix_agentd.log >> c:\zabbix\zabbix_agentd.conf
echo Timeout=5 >> c:\zabbix\zabbix_agentd.conf
echo EnableRemoteCommands=1 >> C:\zabbix\zabbix_agentd.conf
echo HostMetadata=windows >> C:\zabbix\zabbix_agentd.conf

echo Instalando Serviços e Gerando LOGs 

C:\zabbix\zabbix_agentd.exe -i -c C:\zabbix\zabbix_agentd.conf
C:\zabbix\zabbix_agentd.exe -s -c C:\zabbix\zabbix_agentd.conf
net start "zabbix agent"
echo As configuracoes para o servidor %COMPUTERNAME% foram criadas em %date% as %time%
echo As configuracoes para o servidor %COMPUTERNAME% foram criadas em %date% as %time% > c:\zabbix\inst_agent.log
pause
