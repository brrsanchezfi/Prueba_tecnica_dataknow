-- Responda las siguientes preguntas usando comandos de consultas SQL:

------------------------------------------------------------------------------------------------------------------------
--  ¿Cuántos Usuarios gustan del Jazz?

SELECT COUNT(*) AS LIKE_JAZZ
FROM "dev"."public"."users"
WHERE likejazz = true;

------------------------------------------------------------------------------------------------------------------------
-- ¿Cuántos Usuarios gustan de la ópera y del rock al mismo tiempo?

SELECT COUNT(*) AS LIKE_OPERA_ROCK
FROM "dev"."public"."users" AS U
WHERE U.likeopera = TRUE AND U.likerock = TRUE;
-- 3113

------------------------------------------------------------------------------------------------------------------------
-- ¿Cuál es el promedio, moda y mediana del total de Ventas?

--PROMEDIO
SELECT 
  AVG(qtysold) AS promedio_cantidad_vendida, -- promedio de boletos por venta
  AVG(pricepaid) AS promedio_precio_pagado, -- precio promedio pagado por boleto
  AVG(commission) AS promedio_comision -- comision promedio por boleto
FROM "dev"."public"."sales";
-- 2    642.28  96.34	

--MODA
WITH MODA AS (
SELECT  --Evento mas vendido por cantidad de entradas
    eventid,
    SUM(qtysold) AS count_moda_qtysold
FROM "dev"."public"."sales"
GROUP BY eventid
ORDER BY count_moda_qtysold DESC
LIMIT 1)
SELECT E."eventname"
FROM "dev"."public"."event" AS E
RIGHT JOIN MODA 
    ON E."eventid" = MODA.eventid;
-- eventid	count_moda_qtysold
-- 1602	122	
-- Phantom of the Opera	

--MEDIANA
SELECT 
    (SELECT MEDIAN(qtysold) FROM "dev"."public"."sales") AS MEDIAN_qtysold, -- Mediana cantidad de boletas por venta
    (SELECT MEDIAN(pricepaid) FROM "dev"."public"."sales") AS MEDIAN_pricepaid,  -- Mediana valor de venta
    (SELECT MEDIAN(commission) FROM "dev"."public"."sales") AS MEDIAN_commission;  -- Mediana comision

-- median_qtysold	median_pricepaid	median_commission
-- 2	386	57.9	

------------------------------------------------------------------------------------------------------------------------
-- ¿Cuál el promedio de ventas de usuarios que gustan del rock, pero 
-- NO del Jazz?

SELECT 
    AVG( S.pricepaid) AS PROMEDIO_SALES
FROM "dev"."public"."sales" AS S
LEFT JOIN "dev"."public"."users" AS U
    ON S.buyerid = U.userid
WHERE U.likerock = TRUE AND U.likejazz = FALSE