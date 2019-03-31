-- EJERCITARIO 03
-- Funciones de Grupo y Subqueries

-- EJERCICIO 1
--1. El salario de cada empleado está dado por su posición, y  la asignación 
--de la categoría  vigente en dicha posición. Tanto la posición como la 
--categoría vigente tienen la fecha fin nula – Un solo salario está vigente 
--en un momento dado).  Tomando como base la lista de empleados, verifique 
--cuál es el salario máximo, el mínimo y el promedio. Formatee la salida para 
--que se muestren los puntos de mil. 
SELECT  TO_CHAR(MAX(CS.ASIGNACION), '999G999G999') AS SALARIO_MAXIMO,
        TO_CHAR(MIN(CS.ASIGNACION), '999G999G999') AS SALARIO_MINIMO,
        TO_CHAR(AVG(CS.ASIGNACION), '999G999G999') AS SALARIO_PROMEDIO
FROM B_EMPLEADOS E
INNER JOIN B_POSICION_ACTUAL PA ON PA.CEDULA = E.CEDULA
INNER JOIN B_CATEGORIAS_SALARIALES CS ON CS.COD_CATEGORIA = PA.COD_CATEGORIA
WHERE E.CEDULA = PA.CEDULA
      AND PA.FECHA_FIN IS NULL 
      AND CS.FECHA_FIN IS NULL ;

-- EJERCICIO 2
--2. Basado en la consulta anterior, determine la mayor y menor asignación en 
--cada área. Su consulta tendrá: 
--  Nombre de área,  Asignación Máxima, Asignación Mínima. 
SELECT  A.NOMBRE_AREA AREA, MAX(CS.ASIGNACION) ASIGNACION_MAX, 
        MIN(CS.ASIGNACION) ASIGNACION_MIN
FROM B_AREAS A
INNER JOIN B_POSICION_ACTUAL PA ON PA.ID_AREA = A.ID
INNER JOIN B_EMPLEADOS E ON E.CEDULA = PA.CEDULA
INNER JOIN B_CATEGORIAS_SALARIALES CS ON CS.COD_CATEGORIA = PA.COD_CATEGORIA
WHERE E.CEDULA = PA.CEDULA
      AND PA.FECHA_FIN IS NULL 
      AND CS.FECHA_FIN IS NULL 
GROUP BY A.NOMBRE_AREA
ORDER BY 1;

-- EJERCICIO 3
--3. Determine el nombre y apellido, nombre de categoría, asignación y área 
--del empleado (o empleados) que tienen la máxima asignación vigente. 
SELECT  E.NOMBRE, E.APELLIDO, CS.NOMBRE_CAT, CS.ASIGNACION, A.NOMBRE_AREA
FROM B_EMPLEADOS E
INNER JOIN B_POSICION_ACTUAL PA ON PA.CEDULA = E.CEDULA
INNER JOIN B_CATEGORIAS_SALARIALES CS ON CS.COD_CATEGORIA = PA.COD_CATEGORIA
INNER JOIN B_AREAS A ON A.ID = PA.ID_AREA
WHERE CS.ASIGNACION = ( SELECT MAX(CS.ASIGNACION) 
                        FROM B_CATEGORIAS_SALARIALES CS
                        INNER JOIN B_POSICION_ACTUAL PA 
                        ON PA.COD_CATEGORIA = CS.COD_CATEGORIA
                        INNER JOIN B_EMPLEADOS E
                        ON E.CEDULA = PA.CEDULA
                        WHERE E.CEDULA = PA.CEDULA
                              AND PA.FECHA_FIN IS NULL 
                              AND CS.FECHA_FIN IS NULL );

-- EJERCICIO 4
--4. Determine el nombre y apellido, nombre de categoría, asignación y área 
--del empleado (o empleados) que tienen una asignación INFERIOR al promedio. 
--Ordene por monto de salario en forma DESCENDENTE. 
SELECT  E.NOMBRE, E.APELLIDO, CS.NOMBRE_CAT, CS.ASIGNACION, A.NOMBRE_AREA
FROM B_EMPLEADOS E
INNER JOIN B_POSICION_ACTUAL PA ON PA.CEDULA = E.CEDULA
INNER JOIN B_CATEGORIAS_SALARIALES CS ON CS.COD_CATEGORIA = PA.COD_CATEGORIA
INNER JOIN B_AREAS A ON A.ID = PA.ID_AREA
WHERE CS.ASIGNACION < ( SELECT AVG(CS.ASIGNACION) 
                        FROM B_CATEGORIAS_SALARIALES CS
                        INNER JOIN B_POSICION_ACTUAL PA 
                        ON PA.COD_CATEGORIA = CS.COD_CATEGORIA
                        INNER JOIN B_EMPLEADOS E
                        ON E.CEDULA = PA.CEDULA
                        WHERE E.CEDULA = PA.CEDULA
                              AND PA.FECHA_FIN IS NULL 
                              AND CS.FECHA_FIN IS NULL )
ORDER BY CS.ASIGNACION ASC;

-- EJERCICIO 5
--5. Se necesita saber la cantidad de clientes que hay por cada localidad 
--(Tenga en cuenta en la tabla B_PERSONAS sólo aquellas que son clientes). 
--Liste el id, la descripción de la localidad  y la cantidad de clientes. 
--Asegúrese que se listen también las localidades que NO tienen clientes. 
SELECT COUNT(*) FROM B_PERSONAS WHERE ES_CLIENTE =  'S';
SELECT * FROM B_LOCALIDAD ORDER BY 2;

SELECT L.ID, L.NOMBRE, COUNT(P.ID) 
FROM B_LOCALIDAD L
LEFT OUTER JOIN B_PERSONAS P ON L.ID = P.ID_LOCALIDAD
--WHERE P.ES_CLIENTE = 'S' -- NO SE PORQUE NO DEBE DE ESTAR
GROUP BY L.ID, L.NOMBRE
ORDER BY 1;

-- EJERCICIO 6
--6. Liste el volumen (cantidad) y monto de compras y ventas que se hicieron
--por cada artículo durante el año 2011. Debe listar también los artículos 
--que no tuvieron movimiento. Muestre: 
--  ID, ARTICULO  NOMBRE ARTICULO CANT.COMPRAS   MONTO COMPRAS    CANT VENTAS MONTO_VENTAS 
SELECT  A.ID, A.NOMBRE, 
        C.CANT_COMPRAS, C.MONTO_COMPRAS, 
        V.CANT_VENTAS, V.MONTO_VENTAS
FROM B_ARTICULOS A
LEFT OUTER JOIN ( SELECT  DC.ID_ARTICULO, 
                          SUM(DC.CANTIDAD) CANT_COMPRAS,
                          SUM(DC.PRECIO_COMPRA) MONTO_COMPRAS
                  FROM B_DETALLE_COMPRAS DC 
                  INNER JOIN B_COMPRAS C ON C.ID = DC.ID_COMPRA
                  WHERE EXTRACT(YEAR FROM C.FECHA) = 2011
                  GROUP BY DC.ID_ARTICULO
                  ) C
    ON C.ID_ARTICULO = A.ID
LEFT OUTER JOIN ( SELECT  DV.ID_ARTICULO, 
                          SUM(DV.CANTIDAD) CANT_VENTAS,
                          SUM(DV.PRECIO) MONTO_VENTAS
                  FROM B_DETALLE_VENTAS DV 
                  INNER JOIN B_VENTAS V ON V.ID = DV.ID_VENTA
                  WHERE EXTRACT(YEAR FROM V.FECHA) = 2011
                  GROUP BY DV.ID_ARTICULO
                  ) V
    ON V.ID_ARTICULO = A.ID;

-- EJERCICIO 7
--7. Para tener una idea de movimientos, se desea conocer el volumen (cantidad) 
--de ventas por mes  que se hicieron por cada artículo durante el año 2012. 
--Debe listar también los artículos que no tuvieron movimiento. 
--La consulta debe lucir así: 
--  Nombre Artículo  Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic  
SELECT EXTRACT(YEAR FROM C.FECHA) FROM B_COMPRAS C;

SELECT A.NOMBRE NOMBRE_ARTICULO, V.ENE, V.FEB, V.MAR, V.ABR, V.MAY, V.JUN,
        V.JUL, V.AGO, V.SEP, V.OCT, V.NOV, V.DIC
FROM B_ARTICULOS A 
LEFT OUTER JOIN 
        ( SELECT  DV.ID_ARTICULO, 
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 1, DV.CANTIDAD, 0) ) ENE,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 2, DV.CANTIDAD, 0) ) FEB,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 3, DV.CANTIDAD, 0) ) MAR,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 4, DV.CANTIDAD, 0) ) ABR,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 5, DV.CANTIDAD, 0) ) MAY,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 6, DV.CANTIDAD, 0) ) JUN,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 7, DV.CANTIDAD, 0) ) JUL,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 8, DV.CANTIDAD, 0) ) AGO,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 9, DV.CANTIDAD, 0) ) SEP,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 10, DV.CANTIDAD, 0) ) OCT,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 11, DV.CANTIDAD, 0) ) NOV,
            SUM( DECODE(EXTRACT(MONTH FROM V.FECHA), 12, DV.CANTIDAD, 0) ) DIC
          FROM B_DETALLE_VENTAS DV
          INNER JOIN B_VENTAS V  ON V.ID = DV.ID_VENTA
          WHERE EXTRACT (YEAR FROM V.FECHA) = 2011 --CON 2011 TRAE MUCHO
          GROUP BY DV.ID_ARTICULO ) V
ON A.ID = V.ID_ARTICULO 
ORDER BY 1;

-- EJERCICIO 8
--8. Se necesita la cantidad de funcionarios por área. Ordene en forma 
--jerárquica e incluya también la cantidad de funcionarios de las áreas 
--subordinadas de la siguiente manera:  
--          ID      NOMBRE AREA         CANTIDAD CANTIDAD TOTAL  
--    000001        Gerencia General        1          13
--      000002      Gerencia Comercial      1          12
--        000004    Ventas                  6           7
--          000006  Atención al Cliente     0           0
--          000009  Ventas Mayoristas       1           1 
--          000010  Ventas de Salón         0           0            
--        000005    Marketing               4           4                 
--          000007  Promociones             0           0                 
--          000008  Innovación              0           0
SELECT * FROM B_AREAS;

SELECT  LPAD(' ',2*(LEVEL-1))|| TO_CHAR(BAR.ID,'000000') ID, BAR.NOMBRE_AREA,
        CE.CANTIDAD, (  SELECT  SUM(CANTIDAD)     
                        FROM (SELECT A.ID, A.ID_AREA_SUPERIOR,A.NOMBRE_AREA, 
                                      COUNT (CEDULA) CANTIDAD           
                              FROM B_AREAS A           
                              LEFT JOIN  B_POSICION_ACTUAL P                    
                              ON A.ID=P.ID_AREA AND P.FECHA_FIN IS NULL           
                              GROUP BY  A.ID, A.ID_AREA_SUPERIOR,A.NOMBRE_AREA              
                              )A     
                        CONNECT BY PRIOR A.ID = A.ID_AREA_SUPERIOR     
                        START WITH A.ID = BAR.ID      ) CANTIDAD_TOTAL 
FROM B_AREAS BAR
INNER JOIN (  SELECT A.ID, COUNT(PA.CEDULA) CANTIDAD
              FROM B_POSICION_ACTUAL PA
              RIGHT OUTER JOIN B_AREAS A ON A.ID = PA.ID_AREA
              START WITH A.ID = 1
              CONNECT BY PRIOR A.ID = A.ID_AREA_SUPERIOR
              GROUP BY A.ID, A.NOMBRE_AREA
              ORDER BY 1) CE --CANTIDAD EMPLEADOS CE
ON BAR.ID = CE.ID
START WITH BAR.ID = 1
CONNECT BY PRIOR BAR.ID = BAR.ID_AREA_SUPERIOR;

-- EJERCICIO 9
--9. Liste todas las personas del departamento que dependen de Jose Caniza. 
--Incluya no solamente a los subordinados inmediatos, sino también a los que 
--son jerárquicamente dependientes. Liste:
--cédula, nombre y apellido en orden jerárquico.  
SELECT LPAD(' ',2*(LEVEL-1))|| TO_CHAR(E.CEDULA) CEDULA, 
        E.NOMBRE, E.APELLIDO 
FROM B_EMPLEADOS E
START WITH E.CEDULA = ( SELECT JC.CEDULA FROM B_EMPLEADOS JC
                        WHERE UPPER(JC.NOMBRE) LIKE '%JOSE%'
                          AND UPPER(JC.APELLIDO) LIKE '%CA%' )
CONNECT BY PRIOR E.CEDULA = E.CEDULA_JEFE;

-- EJERCICIO 10
--10. Modifique la consulta anterior para averiguar todas las personas que 
--están en un nivel superior al de  Gloria Mendoza.  
SELECT LPAD(' ',2*(4-LEVEL))|| TO_CHAR(E.CEDULA) CEDULA, 
        E.NOMBRE, E.APELLIDO 
FROM B_EMPLEADOS E
--WHERE E.CEDULA NOT IN ( SELECT JC.CEDULA FROM B_EMPLEADOS JC
--                        WHERE UPPER(JC.NOMBRE) LIKE '%GLORIA%'
--                          AND UPPER(JC.APELLIDO) LIKE '%MENDOZA%')
START WITH E.CEDULA = ( SELECT JC.CEDULA FROM B_EMPLEADOS JC
                        WHERE UPPER(JC.NOMBRE) LIKE '%GLORIA%'
                          AND UPPER(JC.APELLIDO) LIKE '%MENDOZA%')
CONNECT BY PRIOR E.CEDULA_JEFE = E.CEDULA
ORDER BY LEVEL DESC;

-- EJERCICIO 11
--11. Liste todas las personas que están en la misma localidad que la 
--firma SERVIMEX. Debe listar:
--identificación (CÉDULA o RUC según tenga), Nombre, Apellido, Nombre Localidad  
SELECT  COALESCE(P.CEDULA, P.RUC) IDENTIFICACION,
        P.NOMBRE,
        NVL(P.APELLIDO, '-') APELLIDO,
        L.NOMBRE
FROM B_PERSONAS P
INNER JOIN B_LOCALIDAD L ON L.ID = P.ID_LOCALIDAD
WHERE P.ID_LOCALIDAD IN ( SELECT ID_LOCALIDAD FROM B_PERSONAS 
                          WHERE UPPER(NOMBRE) LIKE '%SERVIMEX%');

-- EJERCICIO 12
--12. Necesitamos verificar si existen empleados que tienen categorías con 
--asignación inferior al salario mínimo. Liste:
--Cédula, Apellido y Nombre (concatenados), categoría, nombre categoría, 
--asignación. El salario mínimo vigente es guaraníes 1.964.507.  
SELECT E.CEDULA, E.APELLIDO||', '||E.NOMBRE, CS.NOMBRE_CAT, CS.ASIGNACION
FROM B_EMPLEADOS E
INNER JOIN B_POSICION_ACTUAL PA ON PA.CEDULA = E.CEDULA
INNER JOIN B_CATEGORIAS_SALARIALES CS ON CS.COD_CATEGORIA = PA.COD_CATEGORIA
WHERE CS.ASIGNACION < 1964507;
--PARA VERIFICAR SI EXISTE O NO ALGUNO CON SALARIO MENOR AL MINIMO
SELECT COD_CATEGORIA FROM B_POSICION_ACTUAL
INTERSECT
SELECT COD_CATEGORIA FROM B_CATEGORIAS_SALARIALES WHERE ASIGNACION < 1964507;

-- EJERCICIO 13
--13. Verifique las cuentas IMPUTABLES que no han tenido movimiento en el 
--diario de asientos (detalle). Utilice el comando EXISTS en una consulta 
--correlacionada. Liste el código y nombre de la cuenta.
SELECT C.CODIGO_CTA, C.NOMBRE_CTA
FROM B_CUENTAS C
WHERE NOT EXISTS (SELECT CODIGO_CTA
                  FROM B_DIARIO_DETALLE DD
                  WHERE DD.CODIGO_CTA = C.CODIGO_CTA )
      AND C.IMPUTABLE = 'S';
