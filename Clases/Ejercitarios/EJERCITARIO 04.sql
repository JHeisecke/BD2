--EJERCITARIO 4: Sentencias DML

-- EJERCICIO 1
--1. Inserte una nueva area denominada Auditoria con el ID igual al ultimo 
--mas 1, que dependera del ID perteneciente a la Gerencia Administrativa.
SELECT * FROM B_AREAS ORDER BY ID;
INSERT INTO B_AREAS(ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR) 
VALUES 
      ( (SELECT MAX(ID)+1 FROM B_AREAS), --ID
        'Auditoria',                    --NOMBRE_AREA
        TO_DATE(SYSDATE, 'DD/MM/YY'),   --FECHA_CREA
        'S',                            --ACTIVA
        (SELECT ID FROM B_AREAS          --ID_AREA_SUPERIOR
        WHERE NOMBRE_AREA LIKE 'Gerencia Administrativa') ) ;

-- EJERCICIO 2
--2. Inserte el nuevo empleado con los siguientes datos:
--CEDULA: 123568,  NOMBRE APELLIDO: MARCIO BALMACEDA, FECHA_ING: SYSDATE, 
--FECHA_NACIM: 04/02/1970, CEDULA_JEFE: La cedula de Jose Caniza,
--TELEFONO, DIRECCION, BARRIO: El mismo telefono, direccion y barrio
--de su hermano Jose Balmaceda
INSERT INTO B_EMPLEADOS ( CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, 
                          CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD  )
VALUES (  123568 , 'MARCIO2', 'BALMACEDA2', TO_DATE(SYSDATE, 'DD/MM/YY'), '04/02/1970',
          ( SELECT CEDULA FROM B_EMPLEADOS  --CEDULA_JEFE
            WHERE UPPER(NOMBRE) LIKE '%JOSE%' AND UPPER(APELLIDO) LIKE '%CANIZA%') , 
            --de ahora en adelante, los datos de su hermano Jose Balmaceda
          ( SELECT TELEFONO FROM B_EMPLEADOS  --TELEFONO
            WHERE UPPER(NOMBRE) LIKE '%JOSE%' AND UPPER(APELLIDO) LIKE '%BALMACEDA%') ,
          ( SELECT DIRECCION FROM B_EMPLEADOS  --DIRECCION
            WHERE UPPER(NOMBRE) LIKE '%JOSE%' AND UPPER(APELLIDO) LIKE '%BALMACEDA%') ,
          ( SELECT BARRIO FROM B_EMPLEADOS  --BARRIO
            WHERE UPPER(NOMBRE) LIKE '%JOSE%' AND UPPER(APELLIDO) LIKE '%BALMACEDA%') ,
          NULL --ID_LOCALIDAD
        );

-- EJERCICIO 3
--3. Salga del plus sin efectuar el commit. Ingrese de vuelta. Verifique las filas. Explique lo que sucedió
--(al salir se efectúa el commit)
Si se cierra el SQL PLUS sin hacer el commit, todas las sentencias del tipo DML no afectan a las
tablas originales ni a sus datos, porque las operaciones DML son almacenadas en el LOG, que recien
seran confirmadas en un COMMIT para producir efectos permanentes en las tablas existentes;

-- EJERCICIO 4
--4. El Senor Ricardo Meza pasa a tener la misma posicion y area que la 
--Senora Amanda Perez. Realice el cambio en 2 sentencias:
--* ACTUALICE la fecha de fin a la actual posicion de Ricardo Meza
--* INSERTE una nueva posicion para el senor Ricardo Meza, con la categorua y 
--area de la Senora Amanda Perez, y fecha de inicio a partir de hoy.
SELECT * FROM B_POSICION_ACTUAL
WHERE CEDULA IN ( SELECT CEDULA FROM B_EMPLEADOS 
                  WHERE NOMBRE LIKE 'Ricardo' OR NOMBRE LIKE 'Amanda' ) ;
--ACTUALICE la fecha de fin a la actual posicion de Ricardo Meza                
UPDATE B_POSICION_ACTUAL SET FECHA_FIN = TO_DATE(SYSDATE, 'DD/MM/YY')
WHERE FECHA_FIN IS NULL 
  AND CEDULA = (  SELECT CEDULA FROM B_EMPLEADOS 
                  WHERE NOMBRE LIKE 'Ricardo'
                    AND APELLIDO LIKE 'Meza') ;
--INSERTE una nueva posicion para el senor Ricardo Meza                    
INSERT INTO B_POSICION_ACTUAL ( ID, COD_CATEGORIA, CEDULA, 
                                ID_AREA, FECHA_INI, FECHA_FIN )
VALUES (  (SELECT MAX(ID)+1 FROM B_POSICION_ACTUAL ), --ID
          (SELECT COD_CATEGORIA FROM B_POSICION_ACTUAL --COD_CATEGORIA
            WHERE CEDULA = (  SELECT CEDULA FROM B_EMPLEADOS 
                                WHERE NOMBRE LIKE 'Amanda'
                                  AND APELLIDO LIKE 'Perez' ) ),
          (SELECT CEDULA FROM B_EMPLEADOS --CEDULA
                  WHERE NOMBRE LIKE 'Ricardo'
                    AND APELLIDO LIKE 'Meza' ),
          (SELECT ID_AREA FROM B_POSICION_ACTUAL --AREA
            WHERE CEDULA = (  SELECT CEDULA FROM B_EMPLEADOS 
                                WHERE NOMBRE LIKE 'Amanda'
                                  AND APELLIDO LIKE 'Perez' ) ),
          TO_DATE(SYSDATE, 'DD/MM/YY'), --FECHA_INI
          NULL          
        );

-- EJERCICIO 5
--5. Cree la tabla de BONIFICACION (con el script que se proporciona mas abajo) 
--y calcule con una operacion MERGE, la bonificacion correspondiente a 
--todos los empleados. En todos los casos, la bonificacion es igual al total 
--de ventas de cada cedula del vendedor, el cual se calcula sumando el 
--porcentaje de comision que corresponde a cada articulo sobre el costo de venta 
--de dicho articulo de las ventas realizadas hasta la fecha.
--* Cuando el registro de bonificacion ya existe, actualice la bonificacion 
--con el monto calculado
--* Si no existe, inserte el registro correspondiente.
CREATE TABLE BONIFICACION
(CEDULA_VENDEDOR NUMBER(11),
BONIFICACION NUMBER(10));
SELECT * FROM BONIFICACION;

MERGE INTO BONIFICACION B
USING ( SELECT CEDULA_VENDEDOR CEDULA, SUM(MONTO_TOTAL) VENTAS
        FROM B_VENTAS
        GROUP BY CEDULA_VENDEDOR ) V
ON (B.CEDULA_VENDEDOR = V.CEDULA)
WHEN MATCHED THEN 
  UPDATE SET B.BONIFICACION = ROUND(V.VENTAS * 1.05)
WHEN NOT MATCHED THEN 
  INSERT  (B.CEDULA_VENDEDOR, B.BONIFICACION)
  VALUES  (V.CEDULA, ROUND(V.VENTAS * 1.05) );

-- EJERCICIO 6
--6. Se han rematado todos los articulos que no han tenido ventas ni compras 
--en todo el periodo. Elimine fisicamente dichos articulos de la BD.
DELETE FROM B_ARTICULOS 
WHERE ID IN ( --PARA OBTENER EL LISTADO DE ID SIN VENTAS NI COMPRAS
              (SELECT ID FROM B_ARTICULOS
              MINUS 
              SELECT ID_ARTICULO FROM B_DETALLE_VENTAS)
              UNION
              (SELECT ID FROM B_ARTICULOS
              MINUS
              SELECT ID_ARTICULO FROM B_DETALLE_COMPRAS) 
            );

SELECT * FROM B_ARTICULOS ORDER BY 1;

-- EJERCICIO 7
--7. La organizacion ha notado que por un error de proceso, no se ha 
--actualizado el STOCK de los articulos al efectuar las compras.
--ACTUALICE el stock de cada articulo sumandole las respectivas
--cantidades compradas:
UPDATE B_ARTICULOS A
SET A.STOCK_ACTUAL = A.STOCK_ACTUAL + 
                            NVL( (SELECT SUM(CANTIDAD)
                                  FROM B_DETALLE_COMPRAS
                                  WHERE ID_ARTICULO = A.ID) , 0);

-- EJERCICIO 8
--8. Una de las posibilidades que ofrece el ORACLE es la de insertar multiples 
--tablas al mismo tiempo. Corra los siguientes scripts para 
--crear tablas de VENTAS al contado y credito.
CREATE TABLE VENTAS_CONTADO2011
( ID_ARTICULO NUMBER(8),
  MES NUMBER(2),
  CANTIDAD NUMBER(6),
  TOTAL_VENTA NUMBER(8) );

CREATE TABLE VENTAS_CREDITO2011
( ID_ARTICULO NUMBER(8),
  MES NUMBER(2),
  CANTIDAD NUMBER(6),
  TOTAL_VENTA NUMBER(8) );
--Aplique INSERT ... WHEN para insertar en una sola sentencia las ventas de 
--ambos tipos a partir las tablas de VENTAS correspondientes al anho 2011. 
--Atencion: Tipo de venta es CR (credito) o CO (contado).
SELECT * FROM B_VENTAS order by tipo_venta;
SELECT * FROM B_DETALLE_VENTAS;
DESC B_VENTAS;

SELECT * FROM VENTAS_CONTADO2011;
SELECT * FROM VENTAS_CREDITO2011;

INSERT FIRST
  WHEN TIPO_VENTA = 'CO' THEN
    INTO VENTAS_CONTADO2011
    VALUES ( ID_ARTICULO, MES, CANTIDAD, TOTAL_VENTA )
  WHEN TIPO_VENTA = 'CR' THEN
    INTO VENTAS_CREDITO2011
    VALUES ( ID_ARTICULO, MES, CANTIDAD, TOTAL_VENTA )
SELECT  DV.ID_ARTICULO, V.TIPO_VENTA,
        TO_NUMBER(EXTRACT(MONTH FROM V.FECHA)) MES, 
        SUM(DV.CANTIDAD) CANTIDAD, 
        SUM(DV.CANTIDAD * DV.PRECIO) TOTAL_VENTA
  FROM  B_VENTAS V
  INNER JOIN B_DETALLE_VENTAS DV ON DV.ID_VENTA = V.ID
  GROUP BY DV.ID_ARTICULO, V.TIPO_VENTA,
           TO_NUMBER(EXTRACT(MONTH FROM V.FECHA));

-- EJERCICIO 9
--9. Borre de la BD las categorias salariales que historicamente no han sido 
--asignadas a ningun funcionario:
DELETE FROM B_CATEGORIAS_SALARIALES
WHERE COD_CATEGORIA IN (SELECT COD_CATEGORIA FROM B_CATEGORIAS_SALARIALES
                        MINUS
                        SELECT COD_CATEGORIA FROM B_POSICION_ACTUAL);
