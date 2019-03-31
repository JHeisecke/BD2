/*1
Inserte una nueva área denominada “Auditoría” con el ID igual al último
más 1, que dependerá del ID perteneciente a la “Gerencia Administrativa”.
*/
INSERT INTO B_AREAS
VALUES(
SELECT MAX(ID)+1 FROM B_AREAS, 
'Auditoria', sysdate, 
'S',
SELECT ID FROM B_AREAS WHERE UPPER(NOMBRE_AREA)='GERENCIA ADMINISTRATIVA'
);
COMMIT;
SELECT * FROM B_AREAS;

/*4
El Señor Ricardo Meza pasa a tener la misma posición y área que la Señora Amanda Pérez. Realice el cambio en 2 sentencias:
ACTUALICE la fecha de fin a la actual posición de Ricardo Meza-
INSERTE una nueva posición para el señor Ricardo Meza, con la categoría y 
área de la Señora Amanda Pérez, y fecha de inicio a partir de hoy.
*/
UPDATE B_POSICION_ACTUAL
SET FECHA_FIN=SYSDATE
WHERE FECHA_FIN IS NULL AND CEDULA=(
	SELECT CEDULA FROM B_EMPLEADOS WHERE 
	UPPER(NOMBRE)='RICARDO' AND UPPER(APELLIDO)='MEZA'
	)
;
COMMIT;
SELECT A.FECHA_FIN, B.NOMBRE
FROM B_POSICION_ACTUAL A 
JOIN B_EMPLEADOS B
ON A.CEDULA=B.CEDULA
WHERE UPPER(B.NOMBRE)='RICARDO';

INSERT INTO B_POSICION_ACTUAL
VALUES(
	(SELECT MAX(ID)+1 FROM B_POSICION_ACTUAL),
	(SELECT A.COD_CATEGORIA FROM B_POSICION_ACTUAL A
	JOIN B_EMPLEADOS B ON A.CEDULA=B.CEDULA
	WHERE UPPER(B.NOMBRE)='AMANDA' AND UPPER(B.APELLIDO)='PEREZ'),
	(SELECT B.CEDULA FROM B_EMPLEADOS B WHERE UPPER(B.NOMBRE)='RICARDO' AND UPPER(APELLIDO)='MEZA'),
	(SELECT A.ID_AREA FROM B_POSICION_ACTUAL A
	JOIN B_EMPLEADOS B ON A.CEDULA=B.CEDULA
	WHERE UPPER(B.NOMBRE)='AMANDA' AND UPPER(B.APELLIDO)='PEREZ'),
	SYSDATE,
	NULL
);
COMMIT;

/*5
Cree la tabla de BONIFICACION (con el script que se proporciona más abajo) y calcule con una operación MERGE, la bonificación correspondiente a todos los empleados.
En todos los casos, la bonificación es igual al total de ventas de cada cédula del vendedor, 
el cual se calcula sumando el porcentaje de comisión que corresponde a cada artículo sobre el costo de venta de dicho artículo de las ventas realizadas hasta la fecha.
Cuando el registro de bonificación ya existe, actualice la bonificación con el monto calculado
Si no existe, inserte el registro correspondiente.
*/
CREATE TABLE BONIFICACION(
	CEDULA_VENDEDOR NUMBER(11),
	BONIFICACION NUMBER(10)
);

SELECT BV.CEDULA_VENDEDOR CEDULA, SUM(monto_total) Ventas
FROM B_VENTAS BV
JOIN B_DETALLE_VENTAS BD
ON BV.ID=BD.ID_VENTA
JOIN B_ARTICULOS BA
ON BA.ID=BD.ID_ARTICULO;


MERGE INTO BONIFICACION B
USING (
	SELECT BV.CEDULA_VENDEDOR CEDULA, SUM(monto_total) Ventas
	FROM B_VENTAS BV
	JOIN B_DETALLE_VENTAS BD
	ON BV.ID=BD.ID_VENTA
	JOIN B_ARTICULOS BA
	ON BA.ID=BD.ID_ARTICULO
	GROUP BY BV.CEDULA_VENDEDOR
) C
ON (B.CEDULA_VENDEDOR=C.CEDULA)
WHEN MATCHED THEN
	UPDATE SET B.BONIFICACION=C.Ventas*1.05
WHEN NOT MATCHED THEN
	INSERT VALUES(C.CEDULA,C.Ventas*1.05);
	
COMMIT;


/*6
Se han rematado todos los artículos que no han tenido ventas ni compras en todo el periodo. 
Elimine físicamente dichos artículos de la BD.
*/
SELECT BA.ID 
FROM B_ARTICULOS BA
WHERE NOT EXISTS(
	SELECT ID_ARTICULO
	FROM B_DETALLE_COMPRAS BDC
	WHERE BDC.ID_ARTICULO=BA.ID)
	AND
	NOT EXISTS(SELECT ID_ARTICULO
	FROM B_DETALLE_VENTAS BDV
	WHERE BDV.ID_ARTICULO=BA.ID)
;

DELETE FROM B_ARTICULOS
WHERE ID IN (
	SELECT BA.ID 
	FROM B_ARTICULOS BA
	WHERE NOT EXISTS(
		SELECT ID_ARTICULO
		FROM B_DETALLE_COMPRAS BDC
		WHERE BDC.ID_ARTICULO=BA.ID)
		AND
		NOT EXISTS(SELECT ID_ARTICULO
		FROM B_DETALLE_VENTAS BDV
		WHERE BDV.ID_ARTICULO=BA.ID)
);

COMMIT;

/*7
La organización ha notado que por un error de proceso, 
no se ha actualizado el STOCK de los artículos al efectuar las compras. 
ACTUALICE el stock de cada artículo sumándole las respectivas cantidades compradas:
*/
select id_articulo, cantidad from b_detalle_compras order by id_articulo;
select id, stock_actual from b_articulos order by id;

UPDATE B_ARTICULOS A
SET A.STOCK_ACTUAL=A.STOCK_ACTUAL+NVL(
	(select cantidad from b_detalle_compras b
	where a.id=b.id_articulo),0);

commit;

/*
Aplique INSERT ... WHEN para insertar en una 
sola sentencia las ventas de ambos tipos a partir las tablas de
VENTAS correspondienteSELECT  DV.ID_ARTICULO, V.TIPO_VENTA,
        TO_NUMBER(EXTRACT(MONTH FROM V.FECHA)) MES, 
        SUM(DV.CANTIDAD) CANTIDAD, 
        SUM(DV.CANTIDAD * DV.PRECIO) TOTAL_VENTA
  FROM  B_VENTAS V
  INNER JOIN B_DETALLE_VENTAS DV ON DV.ID_VENTA = V.ID
  GROUP BY DV.ID_ARTICULO, V.TIPO_VENTA,
           TO_NUMBER(EXTRACT(MONTH FROM V.FECHA));s al año 2011. Atención: Tipo de venta es 
CR( crédito) o CO (contado).
*/
CREATE TABLE VENTAS_CONTADO2011
(	ID_ARTICULO NUMBER(8),
	MES NUMBER(2),
	CANTIDAD NUMBER(6),
	TOTAL_VENTA NUMBER(8)
);
CREATE TABLE VENTAS_CREDITO2011
(	ID_ARTICULO NUMBER(8),
	MES NUMBER(2),
	CANTIDAD NUMBER(6),
	TOTAL_VENTA NUMBER(8)
);

SELECT * FROM B_VENTAS order by tipo_venta;

INSERT ALL
WHEN TIPO_VENTA = 'CO' THEN
INTO VENTAS_CONTADO2011
VALUES(ID_ARTICULO,MES,CANTIDAD,TOTAL_VENTA)
WHEN TIPO_VENTA = 'CR' THEN
INTO VENTAS_CREDITO2011
VALUES(ID_ARTICULO,MES,CANTIDAD,TOTAL_VENTA)
	SELECT B.ID_ARTICULO, A.TIPO_VENTA,EXTRACT(MONTH FROM A.FECHA) MES, B.CANTIDAD, SUM(B.CANTIDAD * B.PRECIO) TOTAL_VENTA
	FROM B_VENTAS A
	JOIN B_DETALLE_VENTAS B
	ON A.ID=B.ID_VENTA
	GROUP BY B.ID_ARTICULO, EXTRACT(MONTH FROM A.FECHA),A.TIPO_VENTA,B.CANTIDAD
;








