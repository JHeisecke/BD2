--Para ver todas las tablas creadas
SELECT TNAME FROM TAB;

--Ver estructura de tablas
DESC B_PERSONAS;

--formateo de columnas a 20 caracteres
COLUMN NOMBRE_CTA FROM A20
set pagesize 80
SELECT * FROM B_CUENTAS;


--seleccionar cuentas que comiencen con un nivel dado por el teclado
SELECT * FROM B_CUENTAS a WHERE a.NIVEL=&cnivel;

--definir cnivel como 2
DEFINE cnivel=2
SELECT * FROM B_CUENTAS a WHERE a.NIVEL=&cnivel;

/*
Liste los campos id_venta, numero de cuota y monto de las cuotas que vencieron en el primer semestre del año 2011.
También se pide que:
- Ordene los registros resultantes por los campos id_venta, numero_cuota en forma descendente.
- Formatee el campo monto_cuota para que se muestre con separadores de miles.
*/
SELECT ID_VENTA,NUMERO_CUOTA,TO_CHAR(MONTO_CUOTA,'999,999,999,999') 
FROM B_PLAN_PAGO
WHERE VENCIMIENTO BETWEEN '01-ENE-2011' AND '30-JUN-2011'
ORDER BY ID_VENTA, NUMERO_CUOTA DESC;

--Prepare una consulta que recupere los datos de las personas físicas 
--que sean clientes y cuyas direcciones de correo correspondan al proveedor hotmail o gmail.
SELECT * from B_PERSONAS WHERE UPPER(CORREO_ELECTRONICO) LIKE '%HOTMAIL%' OR UPPER(CORREO_ELECTRONICO) LIKE '%GMAIL%';

/*Liste el precio de los artículos existentes, impidiendo que se vean 
los registros repetidos y ordene de mayor a menor.*/
SELECT DISTINCT PRECIO FROM B_ARTICULOS ORDER BY PRECIO DESC;

/*Escriba una consulta que calcule el monto correspondiente a comisiones por vender X
unidades de cada artículo. El valor de X debe ser ingresado por teclado.
La consulta debe mostrar las columnas: Id Artículo, Nombre, Unidad de Medida, Precio,
% Comisión,Sub-Total (Cantidad(X) * Precio),Comisión (Sub-Total * % Comisión)
NOMBRE, UNIDAD_MEDIDA, PRECIO, PORC_COMISION, */
SELECT ID "Id Articulo", NOMBRE, UNIDAD_MEDIDA "Unidad de Medida", PRECIO,
PORC_COMISION "% Comision", (&CANTIDAD * PRECIO) "SUB-TOTAL", 
((&CANTIDAD * PRECIO) * PORC_COMISION) "Comision"
FROM B_ARTICULOS;

/*Escriba una consulta que muestre el código del área y el código del puesto que ocupan
actualmente los emplEados cuyas cédulas son: 1607843,2204219,3008180
Los cargos actuales son aquellos que no tienen valor alguno en el campo FECHA_FIN.*/
SELECT COD_CATEGORIA, ID_AREA FROM B_POSICION_ACTUAL 
WHERE CEDULA IN ('1607843','2204219','3008180') AND FECHA_FIN IS NULL;





