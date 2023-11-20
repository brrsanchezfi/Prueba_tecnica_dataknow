chmod +x ./scripts/entrypoint.sh
#!/bin/bash

# Inicio del servidor SQL Server
/opt/mssql/bin/sqlservr &

# Esperar a que el servidor esté en funcionamiento
sleep 10

# Ejecutar el script de inicialización
/opt/mssql-tools/bin/sqlcmd -U sa -P 'XyZ#2fL9!qo$7aB' -d master -i /scripts/inicializacion.sql
/opt/mssql-tools/bin/sqlcmd -U sa -P 'XyZ#2fL9!qo$7aB' -d master -i /scripts/respuestas.sql

# Mantener el contenedor en ejecución
tail -f /dev/null
