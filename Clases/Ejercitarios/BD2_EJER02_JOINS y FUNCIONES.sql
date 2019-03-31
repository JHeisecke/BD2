/*
El campo FILE_NAME del archivo DBA_DATA_FILES contiene el nombre y camino de los archivos físicos que conforman los espacios de tabla de la Base de Datos. Seleccione:
-Solamente el nombre del archivo (sin mencionar la carpeta o camino):
-Solamente la carpeta o caminino (sin mencionar el archivo)
*/
Select substr(file_name,1, instr(file_name, "\", - 1, 1)) as "Camino",
substr(file_name,1, instr(file_name, '\', - 1, 1)) as "Archivo"
From DBA_DATA_FILES;
"
/*
Obtenga la lista de empleados con su posición y salario vigente 
(El salario y la categoría vigente tienen la fecha fin nula – 
Un solo salario está vigente en un momento dado). Debe listar:
Nombre área, Apellido y nombre del empleado, Fecha Ingreso, categoría, salario actual
La lista debe ir ordenada por nombre de área, y por apellido del funcionario.
*/
select ba.nombre_area, be.nombre||' '||be.apellido as "Nombre y Apellido",
bpa.fecha_ini as "Ingreso", bcs.nombre_cat, bp.salario_basico
from b_empleados be
join b_posicion_actual bpa
on be.cedula = bpa.cedula
join b_areas ba
on ba.id = bpa.id_area
join b_categorias_salariales bcs
on bcs.cod_categoria = bpa.cod_categoria
join b_planilla bp
on bp.cedula = be.cedula
order by ba.nombre_area, be.apellido;

/*
Liste el libro DIARIO correspondiente al mes de febrero del año 2012, tomando en cuenta la cabecera y el detalle. 
Debe listar los siguientes datos:
ID_Asiento, Fecha, Concepto, Nro.Linea, código cuenta, nombre cuenta, Monto débito, Monto crédito 
(haga aparecer el monto del crédito o débito según el valor del campo débito_crédito – D ó C)
*/
SELECT *
FROM B_DIARIO_DETALLE A
JOIN B_DIARIO_CABECER B 
ON B.ID=A.ID
JOIN B_CUENTAS C 
ON C.CODIGO_CTA = A.CODIGO_CTA
WHERE EXTRACT(YEAR FROM A.FECHA) = '2012' 
AND EXTRACT(MONTH FROM A.FECHA) = '02';







