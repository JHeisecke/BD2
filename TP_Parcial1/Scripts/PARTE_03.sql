--Parte 3

--3.1  

--Filas insertadas para el ejercicio (más las que fueron insertadas en la parte 2)

--soc_obligaciones

insert into soc_obligaciones
values (1,extract(year from sysdate),50000,100000,default,1);

insert into soc_obligaciones
values (2,extract(year from sysdate),250000,1000000,'S',1);

insert into soc_obligaciones
values (3,extract(year from sysdate),20000,500000,default,2);

--soc_detalle_obligaciones

insert into soc_detalle_obligaciones
values (1,1,10000,null);

insert into soc_detalle_obligaciones
values (2,1,50000,sysdate);

insert into soc_detalle_obligaciones
values (3,1,5000,sysdate);

insert into soc_detalle_obligaciones
values (3,2,10000,sysdate);

--cre_modalidad_prestamo

insert into cre_modalidad_prestamo
values(1,'ABC',5,1,100,'CA');

insert into cre_modalidad_prestamo
values(2,'DEF',3,2,200,'CD');

insert into cre_modalidad_prestamo
values(3,'AFD',7,3,500,'CD');

--cre_solicitud_prestamo

insert into cre_solicitud_prestamos
values(1,sysdate,'A',10000,1000,50,null,1,null,1);

insert into cre_solicitud_prestamos
values(2,sysdate,'A',20000,5000,50,null,2,null,1);

insert into cre_solicitud_prestamos
values(3,default,'I',20000,55000,50,null,3,null,2);

--cre_prestamos

insert into cre_prestamos
values (1,sysdate,trunc(sysdate)+30,null,500,'A',1);

insert into cre_prestamos
values (2,sysdate,trunc(sysdate)+30,null,250,'I',1);

insert into cre_prestamos
values (3,sysdate,trunc(sysdate)+30,null,1000,'A',2);

insert into cre_prestamos
values (4,sysdate,trunc(sysdate)+30,null,2000,'A',2);

--cre_cuotas

insert into cre_cuotas
values(1,1,50,3,10000,1000,10,trunc(sysdate)+60,sysdate);

insert into cre_cuotas
values(2,1,50,3,20000,1000,10,trunc(sysdate)+60,null);

insert into cre_cuotas
values(3,1,50,3,2000,1000,10,trunc(sysdate)+60,null);

insert into cre_cuotas
values(4,1,50,3,2000,1000,10,trunc(sysdate)+60,null);


--Como vista materializada no permite subquerys, primero, creamos una vista normal, que si acepta

create or replace view N_V
AS select S.ID_SOCIO Id_socio, S.CEDULA Cedula, S.NOMBRE||' '||S.APELLIDO as "Nombre y Apellido",
(select sum(ca.saldo_disponible)
	from soc_socio s2 join aho_cuenta_ahorro ca
	on s2.id_socio = ca.id_socio
	where s2.id_socio = s.id_socio) Disponible,
NVL((select sum(cc.monto_cuota)
	from soc_socio s2 join cre_solicitud_prestamos csp
	on s2.id_socio = csp.socio_deudor
	join cre_prestamos cp
	on csp.id_sol_Cred = cp.id_sol_Cred
	join cre_cuotas cc
	on cp.nro_prestamo = cc.nro_prestamo
	where cp.estado = 'A' and cc.fecha_pago is null and s2.id_socio = s.id_socio),0) Deuda,
NVL((select sum(do.monto)
	from soc_detalle_obligaciones do join soc_obligaciones o
	on do.id_obligacion = o.id_obligacion
	join soc_socio s2
	on o.id_socio = s2.id_socio
	where o.tipo_obligacion = 'A' and do.fecha_pago is not null and s2.id_socio = s.id_socio),0) Aporte
from soc_socio s join aho_cuenta_ahorro ca
on s.id_socio = ca.id_socio
join soc_obligaciones o
on s.id_socio = o.id_socio
join soc_detalle_obligaciones do
on o.id_obligacion = do.id_obligacion
group by S.ID_SOCIO, S.CEDULA, S.NOMBRE||' '||S.APELLIDO;


--Creamos la vista materializada a partir de la vista normal

create materialized view V_SOCIOS
build immediate
refresh start with (sysdate) next (trunc(sysdate)+1) + 22/24
as select * from N_V;

--resultado

select * from V_SOCIOS;

  ID_SOCIO CEDULA       Nombre y Apellido                   DISPONIBLE      DEUDA     APORTE                                                                                                                                                              
---------- ------------ ----------------------------------- ---------- ---------- ----------                                                                                                                                                              
         2 1207876      Roberto Abente Gomez                   2547500       5000      15000                                                                                                                                                              
         1 429987       Jorge Amado Pereira Gonzalez            108500          0          0     


--3.2

--ALD_DECLARACION_JURADA
INSERT INTO ALD_DECLARACION_JURADA
VALUES(1,SYSDATE,'OCUPACION1', NULL,'MOTIVO1',NULL,1);
INSERT INTO ALD_DECLARACION_JURADA
VALUES(2,trunc(SYSDATE)-10,'OCUPACION2',NULL,'MOTIVO2',NULL,1);
INSERT INTO ALD_DECLARACION_JURADA
VALUES(3,SYSDATE,'OCUPACION3',NULL,'MOTIVO3',NULL,2);
INSERT INTO ALD_DECLARACION_JURADA
VALUES(4,trunc(SYSDATE)-5,'OCUPACION4',NULL,'MOTIVO4',NULL,2);

--ALD_CONCEPTOS
INSERT INTO ALD_CONCEPTOS
VALUES(1,'Seguro Medico','G');
INSERT INTO ALD_CONCEPTOS
VALUES(2,'Salario','I');
INSERT INTO ALD_CONCEPTOS
VALUES(3,'Caja de ahorro','I');
INSERT INTO ALD_CONCEPTOS
VALUES(4,'Viatico','G');
INSERT INTO ALD_CONCEPTOS
VALUES(5,'Ventas','I');
INSERT INTO ALD_CONCEPTOS
VALUES(6,'Compras','G');

--ALD_INMUEBLES
INSERT INTO ALD_INMUEBLES
VALUES(1,1,'123456','FINCA1',100,15000,78500);
INSERT INTO ALD_INMUEBLES
VALUES(2,2,'234567','FINCA2',200,20000,77000);
INSERT INTO ALD_INMUEBLES
VALUES(3,1,'345678','FINCA3',300,25000,76000);
INSERT INTO ALD_INMUEBLES
VALUES(4,2,'456789','FINCA4',400,30000,75000);

----ALD_DETALLE_DECLARACION
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(1,132,1500,1);
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(2,345,3750,2);
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(3,234,9750,3);
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(4,22,11000,4);

--Creamos una vista normal porque la materializada no acepta subqueries
create or replace view N_P as
SELECT S.NOMBRE||' '||S.APELLIDO as "Nombre y Apellido", 
(
	SELECT SUM(DECODE(AC2.INGRESO_GASTO, 'I',AD2.IMPORTE,0)-DECODE(AC2.INGRESO_GASTO,'G',AD2.IMPORTE,0)) TOTAL
	FROM ALD_CONCEPTOS AC2
	JOIN ALD_DETALLE_DECLARACION AD2
	ON AC2.ID_CONCEPTO = AD2.ID_CONCEPTO
	JOIN ALD_DECLARACION_JURADA ADJ2
	ON ADJ2.ID_DECLARACION = AD2.ID_DECLARACION
	JOIN SOC_SOCIO S2
	ON S2.ID_SOCIO = ADJ2.ID_SOCIO
	WHERE ADJ2.FECHA_PRESENTACION=(SELECT MAX(FECHA_PRESENTACION)
									FROM ALD_DECLARACION_JURADA ADJ2
									JOIN SOC_SOCIO S3
									ON S3.ID_SOCIO=ADJ2.ID_SOCIO
									WHERE S2.ID_SOCIO=S3.ID_SOCIO
								)
		AND S.ID_SOCIO=S2.ID_SOCIO
) AS "Ingresos",
SUM(DISTINCT AI.VALOR_FISCAL) as "Valor Activos", sum(DISTINCT VS.DISPONIBLE) Disponible,  CP.NRO_PRESTAMO as "Nro Prestamo",
CP.MONTO_PRESTAMO as "Monto Prestamo", CP.FECHA_DESEMBOLSO as "Fecha Desembolso", MAX(CC.FECHA_PAGO) as "Ultima fecha de pago",
(
SELECT
	SUM((CASE WHEN CC2.FECHA_PAGO IS NOT NULL THEN CC2.MONTO_CUOTA + CC2.INTERES_MORATORIO ELSE 0 END)) "Monto Cuotas Pagadas"
FROM CRE_CUOTAS CC2
	JOIN CRE_PRESTAMOS CP2
	ON CC2.NRO_PRESTAMO = CP2.NRO_PRESTAMO
	JOIN CRE_SOLICITUD_PRESTAMOS CSP2
	ON CSP2.ID_SOL_CRED = CP2.ID_SOL_CRED
	JOIN SOC_SOCIO SS
	ON SS.ID_SOCIO = CSP2.SOCIO_DEUDOR OR SS.ID_SOCIO=CSP2.SOCIO_CODEUDOR 
	WHERE S.ID_SOCIO=SS.ID_SOCIO AND CP2.NRO_PRESTAMO =CP.NRO_PRESTAMO
	GROUP BY CC2.NRO_PRESTAMO
) AS "Monto Cuotas Pagadas",
(
	SELECT
	SUM((CASE WHEN CC2.FECHA_PAGO IS NULL THEN CC2.MONTO_CUOTA ELSE 0 END))
	FROM CRE_CUOTAS CC2
	JOIN CRE_PRESTAMOS CP2
	ON CC2.NRO_PRESTAMO = CP2.NRO_PRESTAMO
	JOIN CRE_SOLICITUD_PRESTAMOS CSP2
	ON CSP2.ID_SOL_CRED = CP2.ID_SOL_CRED
	JOIN SOC_SOCIO SS
	ON SS.ID_SOCIO = CSP2.SOCIO_DEUDOR OR SS.ID_SOCIO=CSP2.SOCIO_CODEUDOR
	WHERE SS.ID_SOCIO=S.ID_SOCIO AND CP2.NRO_PRESTAMO =CP.NRO_PRESTAMO
)  AS "Monto cuotas pendientes"
FROM SOC_SOCIO S
JOIN ALD_INMUEBLES AI
ON AI.ID_SOCIO = S.ID_SOCIO
JOIN V_SOCIOS VS
ON VS.Id_socio = S.ID_SOCIO
JOIN CRE_SOLICITUD_PRESTAMOS CSP
ON S.ID_SOCIO = CSP.SOCIO_DEUDOR
JOIN CRE_PRESTAMOS CP
ON CP.ID_SOL_CRED=CSP.ID_SOL_CRED
JOIN CRE_CUOTAS CC
ON CC.NRO_PRESTAMO = CP.NRO_PRESTAMO
WHERE CP.ESTADO='A'
group by S.id_socio, S.cedula, S.NOMBRE||' '||S.APELLIDO, CP.NRO_PRESTAMO, CP.MONTO_PRESTAMO, CP.FECHA_DESEMBOLSO;



--Creamos la vista materializada a partir de la vista normal
create materialized view V_PRESTAMOS
build immediate
refresh start with (sysdate) next (sysdate)+1/24
as select * from N_P;

--Resultado
Nombre y Apellido      Ingresos Valor Activos DISPONIBLE Nro Prestamo Monto Prestamo Fecha Des Ultima fe Monto Cuotas Pagadas Monto cuotas pendientes
-------------------- ---------- ------------- ---------- ------------ -------------- --------- --------- -------------------- -----------------------
Jorge Amado Pereira       -1500         40000    1300000            1            500 25-ABR-19 26-MAR-19                10010                       0
Gonzalez

Roberto Abente Gomez       9750         50000    2575000            3           1000 25-ABR-19                      0                    2000
Roberto Abente Gomez       9750         50000    2575000            4           2000 25-ABR-19                      0                    2000