-- 5. En una nueva tabla junte la información (Nombre de usuario, Apellido de 
-- usuario, Correo de usuario, Nombre del evento, lugar del evento, Fecha 
-- del evento, Cantidad y Total vendidos) y expórtela usando Redshift a un 
-- bucket predefinido de S3.

CREATE TABLE nueva_tabla AS
SELECT 
    S.buyerid AS ID,
    U.firstname AS NOMBRE,
    U.lastname AS APELLIDO,
    U.email AS EMAIL,
    E.eventname AS EVENTO,
    V.venuename AS LUGAR,
    CAST(E.starttime AS DATE) AS FECHA,
    S.qtysold AS CANTIDAD_TICKETS,
    S.pricepaid AS TOTAL_VENDIDO
FROM "dev"."public"."sales" AS S 
    LEFT JOIN "dev"."public"."users" AS U
        ON S.buyerid = U.userid
    LEFT JOIN "dev"."public"."event" AS E
        ON S.eventid = E.eventid
    LEFT JOIN "dev"."public"."venue" AS V
        ON E.venueid = V.venueid
    LEFT JOIN "dev"."public"."date" AS D
        ON S.dateid = D.dateid;

-- Exportar la nueva tabla a un bucket de S3
UNLOAD ('SELECT * FROM nueva_tabla')
TO 's3://demo-pipeline-001/nueva_tabla_'
IAM_ROLE 'arn:aws:iam::575259683139:role/service-role/AmazonRedshift-CommandsAccessRole-20231118T233542'
DELIMITER ',' ALLOWOVERWRITE PARALLEL OFF;

-- Eliminar la tabla temporal si es necesario
DROP TABLE IF EXISTS nueva_tabla;