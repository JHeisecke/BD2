insert into aho_cuenta_ahorro(ID_CUENTA, ID_SOCIO, ESTADO, TASA_INTERES,FECHA_APERTURA,FECHA_CANCEL,SALDO_BLOQUEADO,SALDO_DISPONIBLE)
VALUES(1,1,'A',10,SYSDATE,NULL,541,5400);
insert into aho_cuenta_ahorro(ID_CUENTA, ID_SOCIO, ESTADO, TASA_INTERES,FECHA_APERTURA,FECHA_CANCEL,SALDO_BLOQUEADO,SALDO_DISPONIBLE)
VALUES(2,2,'A',12,SYSDATE,NULL,784,684);
insert into aho_cuenta_ahorro(ID_CUENTA, ID_SOCIO, ESTADO, TASA_INTERES,FECHA_APERTURA,FECHA_CANCEL,SALDO_BLOQUEADO,SALDO_DISPONIBLE)
VALUES(3,3,'A',8,SYSDATE,NULL,1000,5000);
insert into aho_cuenta_ahorro(ID_CUENTA, ID_SOCIO, ESTADO, TASA_INTERES,FECHA_APERTURA,FECHA_CANCEL,SALDO_BLOQUEADO,SALDO_DISPONIBLE)
VALUES(4,4,'A',101,SYSDATE,NULL,5000,7000);
insert into aho_cuenta_ahorro(ID_CUENTA, ID_SOCIO, ESTADO, TASA_INTERES,FECHA_APERTURA,FECHA_CANCEL,SALDO_BLOQUEADO,SALDO_DISPONIBLE)
VALUES(5,5,'A',102,SYSDATE,NULL,4000,10000);
insert into aho_cuenta_ahorro(ID_CUENTA, ID_SOCIO, ESTADO, TASA_INTERES,FECHA_APERTURA,FECHA_CANCEL,SALDO_BLOQUEADO,SALDO_DISPONIBLE)
VALUES(6,6,'A',101,SYSDATE,NULL,3000,11000);


insert into AHO_TIPO_MOVIMIENTO(ID_TIPO,NOMBRE_TIPO,DEBITO_CREDITO)
VALUES(1,'CREDITO FISCAL', 'C');
insert into AHO_TIPO_MOVIMIENTO(ID_TIPO,NOMBRE_TIPO,DEBITO_CREDITO)
VALUES(2,'DEBITO AUTOMATICO', 'D');
insert into AHO_TIPO_MOVIMIENTO(ID_TIPO,NOMBRE_TIPO,DEBITO_CREDITO)
VALUES(3,'DEBITO', 'D');
insert into AHO_TIPO_MOVIMIENTO(ID_TIPO,NOMBRE_TIPO,DEBITO_CREDITO)
VALUES(4,'CREDITO', 'C');

Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(1,SYSDATE,3500,1,1);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(2,SYSDATE,10000,2,1);
Insert into aho_movimientos_cuenta(ID_MOVIMIENTO,FECHA_MOVIMIENTO,IMPORTE,ID_TIPO,ID_CUENTA)
VALUES(3,SYSDATE,3500,1,1);

--AHO_TIPO_MOVIMIENTO--

insert into AHO_TIPO_MOVIMIENTO
values(1,'Deposito','C')
;

insert into AHO_TIPO_MOVIMIENTO
values(2,'Extraccion',default)
;

--AHO_CUENTA_AHORRO--

insert into aho_cuenta_ahorro values(1,1,'A',0.5,sysdate,null,1000,1200000);

insert into aho_cuenta_ahorro
values(2,1,'A',1,sysdate,null,500,100000)
;

insert into aho_cuenta_ahorro
values(3,2,'A',0.5,sysdate,null,1500,2500000)
;

--soc_obligaciones

insert into soc_obligaciones
values (1,extract(year from sysdate),50000,100000,default,1)
;

insert into soc_obligaciones
values (2,extract(year from sysdate),250000,1000000,'S',1)
;

insert into soc_obligaciones
values (3,extract(year from sysdate),20000,500000,default,2)
;


--soc_Detalle_obligaciones

insert into soc_detalle_obligaciones
values (1,1,10000,null)
;

insert into soc_detalle_obligaciones
values (2,1,50000,sysdate)
;

insert into soc_detalle_obligaciones
values (3,1,5000,sysdate)
;

insert into soc_detalle_obligaciones
values (3,2,10000,sysdate)
;


--cre_modalidad_prestamo

insert into cre_modalidad_prestamo
values(1,'ABC',5,1,100,'CA')
;

--insertar uno para probar el check

--cre_solicitud_prestamo

insert into cre_solicitud_prestamos
values(1,sysdate,'A',10000,1000,50,null,1,null,1);

insert into cre_solicitud_prestamos
values(2,sysdate,'A',20000,5000,50,null,2,null,1);

--ingresar otras filas para probar el check del monto concedido y fecha presentacion

--cre_prestamos

insert into cre_prestamos
values (1,sysdate,trunc(sysdate)+30,null,500,'A',1)
;

insert into cre_prestamos
values (2,sysdate,trunc(sysdate)+30,null,250,'I',1)
;

insert into cre_prestamos
values (3,sysdate,trunc(sysdate)+30,null,1000,'A',2)
;

insert into cre_prestamos
values (4,sysdate,trunc(sysdate)+30,null,2000,'A',2)
;

--cre_cuotas
insert into cre_cuotas
values(1,1,50,3,10000,1000,10,trunc(sysdate)+60,sysdate)
;
insert into cre_cuotas
values(2,1,50,3,20000,1000,10,trunc(sysdate)+60,null)
;
insert into cre_cuotas
values(3,1,50,3,2000,1000,10,trunc(sysdate)+60,null)
;
insert into cre_cuotas
values(4,1,50,3,2000,1000,10,trunc(sysdate)+60,null)
;

--ALD_INMUEBLES
INSERT INTO ALD_INMUEBLES
VALUES(1,1,'123456','FINCA1',100,15000,78500);
INSERT INTO ALD_INMUEBLES
VALUES(2,2,'234567','FINCA2',200,20000,77000);
INSERT INTO ALD_INMUEBLES
VALUES(3,3,'345678','FINCA3',300,25000,76000);
INSERT INTO ALD_INMUEBLES
VALUES(4,4,'456789','FINCA4',400,30000,75000);
INSERT INTO ALD_INMUEBLES
VALUES(5,5,'567890','FINCA5',500,35000,72000);

--ALD_DECLARACION_JURADA
INSERT INTO ALD_DECLARACION_JURADA
VALUES(1,SYSDATE,'OCUPACION1', NULL,'MOTIVO1',NULL,1);
INSERT INTO ALD_DECLARACION_JURADA
VALUES(2,SYSDATE,'OCUPACION2',NULL,'MOTIVO2',NULL,2);
INSERT INTO ALD_DECLARACION_JURADA
VALUES(3,SYSDATE,'OCUPACION3',NULL,'MOTIVO3',NULL,3);
INSERT INTO ALD_DECLARACION_JURADA
VALUES(4,SYSDATE,'OCUPACION4',NULL,'MOTIVO4',NULL,4);
INSERT INTO ALD_DECLARACION_JURADA
VALUES(5,SYSDATE,'OCUPACION5',NULL,'MOTIVO5',NULL,5);

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

----ALD_DETALLE_DECLARACION
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(1,132,1500,1);
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(2,345,3750,2);
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(3,234,9750,3);
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(4,22,11000,4);
INSERT INTO ALD_DETALLE_DECLARACION
VALUES(5,112,74500,5);
