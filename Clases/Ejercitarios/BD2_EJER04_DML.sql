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

/*3
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

/*
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
