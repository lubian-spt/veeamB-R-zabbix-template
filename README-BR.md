Observação: É possível que seja necessário algumas alterações no script, ou comando utilizado dependendo do padrão utilizado no nome do job do Veeam.

No template Veeam Backup temos uma discovery, um item prototype, e duas triggers prototypes:

Configurações da Discovery: 

Name: BackupJobs;

Type: Zabbix agent (Active);

Key: discovery.VeeamJobs;

Update interval: 30m;

Keep lost resources period: 1d;

LLD Macro: {#JOBNAME} com JSONPath $..jobname.first()


Configurações do Item Prototype:

Name: {#JOBNAME} - Last Result;

Type: Zabbix agent (Active);

Key: GetLastResult["{#JOBNAME}"];

Type of information: Text;

Update interval: 20m;

History storage period: 60d;

Trend storage period: Do not keep trends;

Create enable: Yes;

Discover: Yes;


Configuração das Triggers:


Trigger warning:

Nome: {#JOBNAME}: Last result was not successful;

Severity: Warning;

Problem expression: last(/Veeam Backup/GetLastResult["{#JOBNAME}"])="Warning";

OK event generation: Recovery Expression;

Recovery expression: last(/Veeam Backup/GetLastResult["{#JOBNAME}"])="Success";

PROBLEM event generation mode: Single;

OK event closes: All events;

Allow manual close: No;

Create enabled: No;

Discover: Yes;


Trigger high:

Nome: {#JOBNAME}: Last result was not successful;

Severity: High;

Problem expression: last(/Veeam Backup/GetLastResult["{#JOBNAME}"])="Failed";

OK event generation: Recovery Expression;

Recovery expression: last(/Veeam Backup/GetLastResult["{#JOBNAME}"])="Success";

PROBLEM event generation mode: Single;

OK event closes: All events;

Allow manual close: No;

Create enabled: Yes;

Discover: Yes;



Configuração necessária nos servidores Veeam:

O script jobdiscovery.ps1 deve ser para o servidor do Veeam.

Os seguintes parâmetros devem ser alterados dentro do .conf do agent:

Timeout=30

UnsafeUserParameters=1

UserParameter=discovery.VeeamJobs[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Caminho\do\script.ps1"

UserParameter=GetLastResult[*],powershell -nologo -command "(get-vbrjob -name '$1' -WarningAction SilentlyContinue).GetLastResult()"


Observação, nesse caso, o $1 está entre aspas simples devido ao nome do job utilizado no ambiente testado.

Após as alterações, salve o arquivo, e faça o restart do serviço do Zabbix agent.

Caso tenha tudo ocorrido como o esperado, os itens devem ser criados dentro de alguns minutos, e suas informações coletadas em seguida.
