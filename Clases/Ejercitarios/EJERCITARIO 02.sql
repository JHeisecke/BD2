-- EJERCITARIO 02 

-- EJERCICIO 1
--1. El campo file_name del archivo DBA_DATA_FILES contiene el nombre y camino 
--de los archivos físicos que conforman los espacios de tabla de la Base de Datos. Seleccione:
-- -Solamente el nombre del archivo (sin mencionar la carpeta o camino)
-- -Solamente la carpeta o camino (sin mencionar el archivo)
DESC DBA_DATA_FILES
SELECT FILE_NAME FROM DBA_DATA_FILES;
  -- NOMBRE DEL ARCHIVO
SELECT SUBSTR(FILE_NAME, INSTR(FILE_NAME, '\', -1, 1) +1) AS FILE_DB
FROM DBA_DATA_FILES;
  -- CARPETA O CAMINO
SELECT SUBSTR(FILE_NAME, 0, INSTR(FILE_NAME, '\', -1, 1) -1) AS PATH_DB
FROM DBA_DATA_FILES;
--PRUEBAS
SELECT DISTINCT INSTR('HOLA GENTE GG', 'G', -1, 3) FROM B_COMPRAS;
SELECT DISTINCT SUBSTR('HOLA GENTE GG', 2, 9) FROM B_COMPRAS;

-- EJERCICIO 2
--2. Obtenga la lista de empleados con su posición y salario vigente 
--(El salario y la categoría vigente tienen la fecha fin nula – Un solo 
--salario está vigente en un momento dado). Debe listar: Nombre área,
--Apellido y nombre del empleado, Fecha Ingreso, categoría, salario actual
--La lista debe ir ordenada por nombre de área, y por apellido del funcionario.
SELECT A.NOMBRE_AREA, B.APELLIDO ||', '|| B.NOMBRE, 
       C.FECHA_INI, D.NOMBRE_CAT, D.ASIGNACION
FROM B_POSICION_ACTUAL C 
JOIN B_AREAS A ON A.ID = C.ID_AREA
JOIN B_EMPLEADOS B ON B.CEDULA = C.CEDULA
JOIN B_CATEGORIAS_SALARIALES D ON D.COD_CATEGORIA = C.COD_CATEGORIA
WHERE C.FECHA_FIN IS NULL 
  AND D.FECHA_FIN IS NULL 
ORDER BY A.NOMBRE_AREA, B.APELLIDO;

-- EJERCICIO 3
--3. Liste el libro DIARIO correspondiente al mes de enero del año 2012, 
--tomando en cuenta la cabecera y el detalle. Debe listar los siguientes datos:
--ID_Asiento, Fecha, Concepto, Nro.Linea, código cuenta, nombre cuenta, 
--Monto débito, Monto crédito (haga aparecer el monto del crédito o débito 
--según el valor del campo débito_crédito – D ó C)
SELECT B.ID, B.FECHA, B.CONCEPTO, A.NRO_LINEA, C.CODIGO_CTA, C.NOMBRE_CTA,
DECODE(A.DEBE_HABER, 'C', A.IMPORTE, 0) AS CREDITO,
DECODE(A.DEBE_HABER, 'D', A.IMPORTE, 0) AS DEBITO
FROM B_DIARIO_DETALLE A
INNER JOIN B_DIARIO_CABECERA B ON B.ID = A.ID
INNER JOIN B_CUENTAS C ON C.CODIGO_CTA = A.CODIGO_CTA
WHERE EXTRACT(MONTH FROM B.FECHA) = 1 
  AND EXTRACT(YEAR FROM B.FECHA) = 2012; 

-- EJERCICIO 4
--4. Algunos empleados de la empresa son también clientes. Obtenga dicha 
--lista a través de una operación de intersección. Liste cédula, nombre y 
--apellido, teléfono. Tenga en cuenta sólo a las personas físicas (F) que 
--tengan cédula. Recuerde que los tipos de datos para operaciones del álgebra 
--relacional tienen que ser los mismos.
SELECT TO_CHAR(E.CEDULA) CEDULA, E.NOMBRE ||' '|| E.APELLIDO NOMBRE, E.TELEFONO 
FROM B_EMPLEADOS E
  INTERSECT
SELECT P.CEDULA, P.NOMBRE ||' '|| P.APELLIDO AS NOMBRE, P.TELEFONO 
FROM B_PERSONAS P
WHERE P.TIPO_PERSONA LIKE 'F' 
  AND P.CEDULA IS NOT NULL;
  
-- EJERCICIO 5
--5. Se pretende realizar el aumento salarial del 5% para todas las categorías. 
--Debe listar la categoría (código y nombre), el importe actual, el importe 
--aumentado al 5% (redondeando la cifra a la centena), y la diferencia.
--Formatee la salida para que los montos tengan los puntos de mil.
SELECT COD_CATEGORIA, NOMBRE_CAT, 
    TO_CHAR(ASIGNACION, '999,999,999') AS IMPORTE_ANTERIOR, 
    TO_CHAR(ROUND(ASIGNACION*1.05, 2), '999,999,999') AS IMPORTE_NUEVO,
    TO_CHAR(ROUND(ASIGNACION*1.05, 2) - ASIGNACION, '999,999,999') AS DIFERENCIA
FROM B_CATEGORIAS_SALARIALES;

-- EJERCICIO 6
--6. Se necesita tener la lista completa de personas (independientemente de 
--su tipo), ordenando por nombre de localidad. Si la persona no tiene asignada 
--una localidad, también debe aparecer. Liste Nombre de Localidad, Nombre y 
--apellido de la persona, dirección, teléfono
SELECT L.NOMBRE, P.NOMBRE||' '||P.APELLIDO NOMBRE_PER, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
LEFT OUTER JOIN B_LOCALIDAD L ON L.ID = P.ID_LOCALIDAD
ORDER BY 1;

-- EJERCICIO 7
--7. En base a la consulta anterior, liste todas las localidades, 
--independientemente que existan personas en dicha localidad:
SELECT L.NOMBRE, P.NOMBRE||' '||P.APELLIDO NOMBRE_PER, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
RIGHT OUTER JOIN B_LOCALIDAD L ON L.ID = P.ID_LOCALIDAD
ORDER BY 1;
-- VERSION DONDE SE EVITA APARECER EL (null) O VACÍO, USANDO DECODE
SELECT L.NOMBRE, 
      DECODE(P.NOMBRE, NULL, '-', P.NOMBRE||' '||P.APELLIDO) NOMBRE_PER, 
      DECODE(P.DIRECCION, NULL, '-', P.DIRECCION) DIRECCION, 
      DECODE(P.TELEFONO, NULL, '-', P.TELEFONO) TELEFONO
FROM B_PERSONAS P
RIGHT OUTER JOIN B_LOCALIDAD L ON L.ID = P.ID_LOCALIDAD
ORDER BY 1;

-- EJERCICIO 8
--8. Obtenga la misma lista del ejercicio 5, pero asegurándose de listar 
--todas las personas, independientemente que estén asociadas a una localidad, 
--y todas las localidades, aún cuando no tengan personas asociadas.
SELECT E.NOMBRE||' '||E.APELLIDO AS NOMBRE_PER, L.NOMBRE AS NOM_LOCALIDAD,
    C.COD_CATEGORIA AS COD_CAT, C.NOMBRE_CAT, 
    TO_CHAR(C.ASIGNACION, '999,999,999') AS IMPORTE_ANTERIOR, 
    TO_CHAR(ROUND(C.ASIGNACION*1.05, 2), '999,999,999') AS IMPORTE_NUEVO,
    TO_CHAR(ROUND(C.ASIGNACION*1.05, 2)-C.ASIGNACION,'999,999,999') DIFERENCIA
FROM B_EMPLEADOS E
INNER JOIN B_POSICION_ACTUAL PA ON PA.CEDULA = E.CEDULA
INNER JOIN B_CATEGORIAS_SALARIALES C ON C.COD_CATEGORIA = PA.COD_CATEGORIA
FULL OUTER JOIN B_LOCALIDAD L ON L.ID = E.ID_LOCALIDAD;

-- EJERCICIO 9
--9. Considerando la fecha de hoy,  indique cuándo caerá el próximo DOMINGO. 
SELECT NEXT_DAY(SYSDATE, 1) AS PROXIMO_DOMINGO FROM DUAL;

-- EJERCICIO 10
--10. Suponiendo que estamos el 1 de Febrero del 2014, utilice la función 
--LAST_DAY para determinar si este año es bisiesto o no. Con CASE y con DECODE, 
--haga aparecer la expresión ‘bisiesto’ o ‘no bisiesto’ según corresponda.  
--Pruebe también con la fecha de hoy.
SELECT DECODE(LAST_DAY('01/02/2014'),'29/02/14','ES BISIESTO','NO ES BISIESTO')
          AS ES_BISIESTO 
FROM DUAL;

SELECT DECODE(LAST_DAY( '01/02/'||EXTRACT(YEAR FROM SYSDATE) ), 
            --Busca el ultimo día en base al mes de febrero del año corriente
              '29/02/'||EXTRACT(YEAR FROM SYSDATE),
            --Compara con el hipotético 29 de febrero del año corriente
                'ES BISIESTO', 'NO ES BISIESTO')
                -- SI CUMPLE    --SI NO CUMPLE
          AS ES_BISIESTO 
FROM DUAL;

-- EJERCICIO 11
--11. Tomando en cuenta la fecha de hoy, verifique que fecha dará redondeando 
--al año? Y truncando al año? Escriba el resultado.  Pruebe lo mismo suponiendo 
--que sea el 1 de Julio del año. Pruebe también el 12 de marzo.
  --REDONDEO AL AÑO
SELECT ROUND(SYSDATE, 'YEAR') FROM DUAL;
  --TRUNCAMIENTO AL AÑO
SELECT TRUNC(SYSDATE, 'YEAR') FROM DUAL;
  --REDONDEO AL 01 DE JULIO DEL CORRIENTE AÑO
SELECT ROUND(TO_DATE('01/07/'||EXTRACT(YEAR FROM SYSDATE)), 'YEAR') 
FROM DUAL;
  --TRUNCAMIENTO AL 01 DE JULIO DEL CORRIENTE AÑO
SELECT TRUNC(TO_DATE('01/07/'||EXTRACT(YEAR FROM SYSDATE)), 'YEAR') 
FROM DUAL;
  --REDONDEO AL 01 DE JULIO DEL CORRIENTE AÑO
SELECT ROUND(TO_DATE('12/03/'||EXTRACT(YEAR FROM SYSDATE)), 'YEAR') 
FROM DUAL;
  --TRUNCAMIENTO AL 01 DE JULIO DEL CORRIENTE AÑO
SELECT TRUNC(TO_DATE('12/03/'||EXTRACT(YEAR FROM SYSDATE)), 'YEAR') 
FROM DUAL;

-- EJERCICIO 12
--12. Imprima su edad en años y meses. Ejemplo: Si nació el 23/abril/1972, 
--tendría 43 años y 3 meses a la fecha.
SELECT  ROUND( (SYSDATE-TO_DATE('01/08/1997'))/365 ) AS EDAD_ANHOS,
        ROUND( (MOD((SYSDATE-TO_DATE('01/08/1997')), 365))/30, 1) AS EDAD_MESES
FROM DUAL;

-- EJERCICIO 13
--13. Determine la fecha y hora del sistema en el formato apropiado.  
SELECT SUBSTR(systimestamp, 0, INSTR(systimestamp, ',')-1 ) SYSTEM_DATE_TIME 
FROM DUAL;

-- EJERCICIO 14
--14. Liste  ID y NOMBRE de todos los artículos que no están incluidos en 
--ninguna VENTA. Debe utilizar necesariamente la sentencia MINUS. 
SELECT A.ID, A.NOMBRE FROM B_ARTICULOS A
MINUS
SELECT DV.ID_ARTICULO, B.NOMBRE FROM B_DETALLE_VENTAS DV
INNER JOIN B_ARTICULOS B ON B.ID = DV.ID_ARTICULO;

-- EJERCICIO 15
--15. La organización ha decidido mantener un registro único de todas las 
--personas, sean éstas proveedores, clientes y/o empleados. Para el efecto se 
--le pide una operación de UNION entre las tablas de B_PERSONAS y B_EMPLEADOS.  
--Debe listar: 
--  CEDULA, APELLIDO, NOMBRE,  DIRECCION, TELEFONO, FECHA_NACIMIENTO. 
--En la tabla PERSONAS tenga únicamente en cuenta las personas de tipo 
--FISICAS (F) y que tengan cédula. Ordene la consulta por apellido y nombre 
SELECT CEDULA, APELLIDO, NOMBRE, DIRECCION, TELEFONO, FECHA_NACIMIENTO
FROM B_PERSONAS
WHERE TIPO_PERSONA = 'F' AND CEDULA IS NOT NULL
UNION
SELECT TO_CHAR(CEDULA), APELLIDO, NOMBRE, DIRECCION, TELEFONO, FECHA_NACIM
FROM B_EMPLEADOS
ORDER BY 2,3;


