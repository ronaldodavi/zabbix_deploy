@echo off
runas /user:dominio\administrator
REM #MODULO 1#
IF EXIST "c:\Zabbix\zabbix_agentd.exe" (exit) ELSE (echo "Iniciando a instalacao do Zabbix Agent")
REM #
REM # Exibe mensagem na tela#
echo Copiando Arquivos

REM #MODULO 2 - Criar o diretório na máquina#
mkdir c:\zabbix
echo Pasta zabbix criada no C:

REM #MODULO 3 - Realiza a cópia dos binários para o sistema#

bitsadmin /transfer zagt /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/zabbix_agentd.exe c:\zabbix\zabbix_agentd.exe
bitsadmin /transfer zget /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/zabbix_get.exe c:\zabbix\zabbix_get.exe
bitsadmin /transfer zgsed /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/agent-v4-lts/zabbix_sender.exe c:\zabbix\zabbix_sender.exe
bitsadmin /transfer zconf /priority high https://raw.githubusercontent.com/ronaldodavi/zabbix_deploy/main/zabbix_agentd.conf c:\zabbix\zabbix_agentd.conf

REM #MODULO 4 *PUNK* - Cria arquivo de configuração e define nome do servidor #
echo Criando Arquivos de configuracao
echo Server=192.168.0.254 > c:\zabbix\zabbix_agentd.conf
echo Hostname=%COMPUTERNAME% >> c:\zabbix\zabbix_agentd.conf
echo StartAgents=5 >> c:\zabbix\zabbix_agentd.conf
echo DebugLevel=3 >> c:\zabbix\zabbix_agentd.conf
echo LogFile=c:\zabbix\zabbix_agentd.log >> c:\zabbix\zabbix_agentd.conf
echo Timeout=5 >> c:\zabbix\zabbix_agentd.conf
echo EnableRemoteCommands=1 >> C:\zabbix\zabbix_agentd.conf

REM #MODULO 4 - Ajustes Finais #
echo Instalando o Serviço
C:\zabbix\zabbix_agentd.exe -i -c C:\zabbix\zabbix_agentd.conf
C:\zabbix\zabbix_agentd.exe -s -c C:\zabbix\zabbix_agentd.conf
echo As configuracoes para o servidor %COMPUTERNAME% foram criadas em %date% as %time%
echo As configuracoes para o servidor %COMPUTERNAME% foram criadas em %date% as %time% > c:\zabbix\inst_agent.log
pause
