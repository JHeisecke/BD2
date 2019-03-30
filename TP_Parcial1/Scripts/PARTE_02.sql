--formato recomendado
set pagesize 90
set linesize 250
column nombre format a20
column apellido format a20
column "Nombre y Apellido" format A35
column firma format a10
column direccion format a30
column email format A37
column descripcion_mod format A10


--Parte 2

--2.4

create sequence SEQ_SOCIO
start with 1
increment by 1;

--2.5

--sin incluir columna estado, porque como al no incluirle si o si se le agrega su default 
--y "bp.cedula is not null" porque hay filas en la tabla b_personas que tienen el campo cedula null, y la tabla soc_socio no acepta eso

insert into soc_socio (ID_SOCIO, CEDULA, RUC, NOMBRE, APELLIDO, FECHA_NACIMIENTO, FECHA_INGRESO, DIRECCION, TELEFONO, EMAIL, SUSCRIPTO_NOVEDADES, FECHA_FALLECIMIENTO, FECHA_BAJA)
select SEQ_SOCIO.nextval, BP.CEDULA, BP.RUC, BP.NOMBRE, BP.APELLIDO, BP.FECHA_NACIMIENTO, SYSDATE, BP.DIRECCION, BP.TELEFONO, BP.CORREO_ELECTRONICO, 'N', 
NULL, NULL FROM BASEDATOS2.B_PERSONAS BP WHERE TIPO_PERSONA = 'F' and bp.cedula is not null;

commit;

--resultado

select * from soc_socio;

  ID_SOCIO CEDULA       RUC          NOMBRE               APELLIDO             FECHA_NAC FECHA_ING DIRECCION                      TELEFONO             EMAIL                                 S FIRMA      E FECHA_FAL FECHA_BAJ                           
---------- ------------ ------------ -------------------- -------------------- --------- --------- ------------------------------ -------------------- ------------------------------------- - ---------- - --------- ---------                           
         1 429987                    Jorge Amado          Pereira Gonzalez     10-ENE-80 16-MAR-19 Dr. Molinas c/ Juan de Salazar 021601382            jpereira@hotmail.com                  N            A                                               
         2 1207876                   Roberto              Abente Gomez         30-OCT-67 16-MAR-19 Juan B. Gill e/ J.G Benitez    021558676            rag939@live.com                       N            A                                               
         3 310098       310098-1     Reina                Rios                 07-MAR-78 16-MAR-19 Ruta San Lorenzo a Luque       021649580            rr1949@gmail.com                      N            A                                               
         4 1298876      1298876-0    Roque                Talavera             10-ENE-75 16-MAR-19 Inocencio Lezcano Nº 1338     021229292            roque@rieder.net                      N            A                                               
         5 2209982      2209982-9    Ramon                Gauto                01-JUN-90 16-MAR-19 Pte.Franco y Montevideo        021446097            ramongauto_construcciones@gmail.com   N            A                                               
         6 1984562      1984562-1    Juan I.              Reyez S.             02-FEB-87 16-MAR-19 Ayolas Esq.Pte.Franco N°1298  0985339287           jirs_com@yahoo.com                    N            A                                               
         7 334654       334654-4     Bienvenido           Alfonso Santos       07-JUN-70 16-MAR-19 Yacyreta c/ Gral. Diaz         0521204123           bienvenido.alfonso@                   N            A                                               
         8 883393       883393-2     Mario Luis           Martinez             01-MAR-90 16-MAR-19 Felix Bogado y 4ta.            02302991             mario@hotmail.com                     N            A               


--2.6

alter table cre_modalidad_prestamo
modify descripcion_mod varchar2(100);

--resultado

desc cre_modalidad_prestamo;
 Name                                                                                                                                            Null?    Type
 ----------------------------------------------------------------------------------------------------------------------------------------------- -------- ------------------------------------------------------------------------------------------------
 COD_TIPO                                                                                                                                        NOT NULL NUMBER(3)
 DESCRIPCION_MOD                                                                                                                                 NOT NULL VARCHAR2(100)
 TASA_INTERES_ANUAL                                                                                                                                       NUMBER(3,1)
 RELACION_APORTES                                                                                                                                         NUMBER(2)
 PLAZO_MAXIMO                                                                                                                                             NUMBER(3)
 TIPO_GARANTIA                                                                                                                                            VARCHAR2(2)


--2.7

--Filas insertadas para el ejercicio

insert into AHO_TIPO_MOVIMIENTO
values(1,'Deposito','C');

insert into AHO_TIPO_MOVIMIENTO
values(2,'Extraccion',default);

insert into aho_cuenta_ahorro
values(1,1,default,0.5,sysdate,null,1000,1200000);

insert into aho_cuenta_ahorro
values(2,1,default,1,sysdate,null,500,100000);

insert into aho_cuenta_ahorro
values(3,2,default,0.5,sysdate,null,1500,75000);

insert into aho_cuenta_ahorro
values(4,2,default,0.5,sysdate,null,100,2500000);


Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(1,SYSDATE,3500,1,1);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(2,SYSDATE,10000,1,1);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(3,SYSDATE,1500,2,1);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(4,SYSDATE,500,2,1);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(7,SYSDATE,50000,1,3);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(5,SYSDATE,500,2,3);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(6,SYSDATE,500,2,3);


--Actualizacion

merge into aho_cuenta_ahorro aca
using (
select aca.id_cuenta, 
(select sum(amc.importe)
from aho_cuenta_ahorro aca2 join aho_movimientos_cuenta amc
on aca2.id_cuenta = amc.id_cuenta
JOIN AHO_TIPO_MOVIMIENTO atm
ON amc.ID_TIPO = atm.ID_TIPO
where atm.debito_credito='C'and aca.id_cuenta = aca2.id_cuenta) 
-
(select sum(amc.importe)+aca2.saldo_bloqueado
from aho_cuenta_ahorro aca2 join aho_movimientos_cuenta amc
on aca2.id_cuenta = amc.id_cuenta
JOIN AHO_TIPO_MOVIMIENTO atm
ON amc.ID_TIPO = atm.ID_TIPO
where atm.debito_credito='D' and aca.id_cuenta = aca2.id_cuenta
group by aca2.id_cuenta, aca2.saldo_bloqueado) Resta
from aho_cuenta_ahorro aca join aho_movimientos_cuenta amc
on aca.id_cuenta = amc.id_cuenta
JOIN AHO_TIPO_MOVIMIENTO atm
ON amc.ID_TIPO = atm.ID_TIPO
group by aca.id_cuenta
) R
on (aca.id_cuenta = R.id_cuenta)
when matched then
	update set aca.saldo_disponible = R.Resta

--Resultado
select * from aho_cuenta_ahorro;

 ID_CUENTA   ID_SOCIO E TASA_INTERES FECHA_APE FECHA_CAN SALDO_BLOQUEADO SALDO_DISPONIBLE
---------- ---------- - ------------ --------- --------- --------------- ----------------
         1          1 A            1 24-MAR-19                      1000            10500
         2          1 A            1 24-MAR-19                       500           100000
         3          2 A            1 24-MAR-19                      1500            47500
         4          2 A            1 24-MAR-19                       100          2500000       

