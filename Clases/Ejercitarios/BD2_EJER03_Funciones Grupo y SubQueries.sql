column "Nombre y Apelllido" format A25;
SET LINESIZE 200;
/*7
Para tener una idea de movimientos, se desea conocer el volumen (cantidad) de ventas por mes 
que se hicieron por cada artículo durante el año 2011. 
Debe listar también los artículos que no tuvieron movimiento.
La consulta debe lucir así:___________________
Nombre articulo + Ene + Feb + Mar + Abr + May |
________________|_____|_____|_____|_____|_____|
*/
SELECT 
	A.NOMBRE,
	SUM( DECODE(EXTRACT(MONTH FROM V.FECHA),1, DV.CANTIDAD, 0)) "Ene",
	SUM( DECODE(EXTRACT(MONTH FROM V.FECHA),2, DV.CANTIDAD, 0)) "Feb",
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
JOIN B_VENTAS V
ON V.ID=DV.ID_VENTA
JOIN B_ARTICULOS A
ON A.ID=DV.ID_ARTICULO
GROUP BY A.NOMBRE;

/*8
Se necesita la cantidad de funcionarios por área. 
Ordene en forma jerárquica e incluya también la cantidad de 
funcionarios de las áreas subordinadas de la siguiente manera:
*/
SELECT A.ID, A.NOMBRE_AREA,COUNT(E.CEDULA) AS CANTIDAD
FROM B_AREAS A
JOIN B_POSICION_ACTUAL PA
ON A.ID=PA.ID_AREA
JOIN B_EMPLEADOS E
ON PA.CEDULA=E.CEDULA
GROUP BY A.ID,A.NOMBRE_AREA;

/*10
Liste todas las personas del departamento que dependen de Jose Caniza. 
Incluya no solamente a los subordinados inmediatos, 
sino también a los que son jerárquicamente dependientes. 
Liste cédula, nombre y apellido en orden jerárquico.
*/

/*12
Liste todas las personas que están en la misma localidad que la firma SERVIMEX. 
Debe listar identificación (CÉDULA o RUC según tenga), Nombre, Apellido, Nombre Localidad
*/
select id_localidad
from b_personas 
where UPPER(nombre) like '%SERVIMEX%';

select 
COALESCE(BP.CEDULA,BP.RUC) "IDENTIFICACION",
BP.NOMBRE, BP.APELLIDO, BL.NOMBRE
from b_personas BP
join b_localidad BL
on BP.id_localidad=BL.id
WHERE BP.ID_LOCALIDAD = (select id_localidad
						from b_personas 
						where UPPER(nombre) like '%SERVIMEX%')

;
/*14
Verifique las cuentas IMPUTABLES que no han tenido movimiento en el diario de asientos (detalle). 
Utilice el comando EXISTS en una consulta correlacionada. Liste el código y nombre de la cuenta
*/
SELECT C.CODIGO_CTA, C.NOMBRE_CTA
FROM B_CUENTAS C
WHERE C.IMPUTABLE='S' AND 
NOT EXISTS (SELECT CODIGO_CTA FROM B_DIARIO_DETALLE BDD WHERE C.CODIGO_CTA=BDD.CODIGO_CTA);

/*15
El Dpto. De RRHH requiere un reporte que liste los siguientes datos de los empleados:
Cedula. Nombre y Apellido (Concatenados). Antigüedad (Expresada en años). 
Cantidad de cargos ocupados en los primeros cinco años de permanencia en la empresa. 
Promedio salarial de los cargos ocupados en los primeros cinco años de permanencia en la empresa.
*/

SELECT BE.CEDULA,BE.NOMBRE||' '||BE.APELLIDO AS "Nombre y Apellido",(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM FECHA_ING)) AS "Antiguedad",
COUNT(BP.FECHA_INI)
FROM B_EMPLEADOS BE
JOIN B_POSICION_ACTUAL BP
ON BP.CEDULA=BE.CEDULA
GROUP BY BE.CEDULA, BE.NOMBRE||' '||BE.APELLIDO,(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM FECHA_ING));



/*16
Liste por cada área él o los empleados que más recientemente fueron incorporados a la empresa por cada una de las áreas. 
Filtre la consulta por las áreas activas y por aquellos empleados que ocupan cargos actuales en dichas áreas. 
Los campos a mostrar son: ID Área, Nombre de Área, Cedula de Empleado, Nombre/ Apellido y Fecha de ingreso.
*/
SELECT A.ID, A.NOMBRE_AREA, E.CEDULA, E.NOMBRE, E.APELLIDO,E.FECHA_ING
FROM B_AREAS A
JOIN B_POSICION_ACTUAL PA
ON A.ID=PA.ID_AREA
JOIN B_EMPLEADOS E
ON PA.CEDULA=E.CEDULA
WHERE PA.FECHA_FIN IS NULL AND
A.ACTIVA='S' AND
(A.ID, PA.FECHA_INI) IN (SELECT A.ID, MAX(PA.FECHA_INI)
FROM B_AREAS A JOIN B_POSICION_ACTUAL PA
ON A.ID = PA.ID_AREA
GROUP BY A.ID)
ORDER BY A.ID;