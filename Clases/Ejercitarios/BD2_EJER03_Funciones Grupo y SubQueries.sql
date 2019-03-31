/*
Para tener una idea de movimientos, se desea conocer el volumen (cantidad) de ventas por mes 
que se hicieron por cada artículo durante el año 2012. 
Debe listar también los artículos que no tuvieron movimiento.
La consulta debe lucir así:___________________
Nombre articulo + Ene + Feb + Mar + Abr + May |
________________|_____|_____|_____|_____|_____|



/*
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




/*
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