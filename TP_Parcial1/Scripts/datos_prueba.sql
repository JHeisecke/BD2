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