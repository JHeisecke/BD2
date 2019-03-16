---4---
create sequence SEQ_SOCIO
start with 1
increment by 1
;

---5---
--sin estado default (porque como al no incluirle si o si se le agrega su default)
insert into soc_socio (ID_SOCIO, CEDULA, RUC, NOMBRE, APELLIDO, FECHA_NACIMIENTO, FECHA_INGRESO, DIRECCION, TELEFONO, EMAIL, SUSCRIPTO_NOVEDADES, FECHA_FALLECIMIENTO, FECHA_BAJA)
select SEQ_SOCIO.nextval, BP.CEDULA, BP.RUC, BP.NOMBRE, BP.APELLIDO, BP.FECHA_NACIMIENTO, SYSDATE, BP.DIRECCION, BP.TELEFONO, BP.CORREO_ELECTRONICO, 'N', 
NULL, NULL FROM BASEDATOS2.B_PERSONAS BP WHERE TIPO_PERSONA = 'F' and bp.cedula is not null

commit;


---6---
alter table cre_modalidad_prestamo
modify descripcion_mod varchar2(100)
;


---7---
UPDATE AHO_CUENTA_AHORRO
SET SALDO_DISPONIBLE= (
	(SELECT SUM(A.IMPORTE)
	FROM AHO_MOVIMIENTOS_CUENTA A
	JOIN AHO_TIPO_MOVIMIENTO B
	ON A.ID_TIPO = B.ID_TIPO
	JOIN AHO_CUENTA_AHORRO C
	ON A.ID_CUENTA = C.ID_CUENTA
	WHERE B.DEBITO_CREDITO='C'
	GROUP BY A.ID_CUENTA)
 -
	(SELECT SUM(A.IMPORTE+C.SALDO_BLOQUEADO)
	FROM AHO_MOVIMIENTOS_CUENTA A
	JOIN AHO_TIPO_MOVIMIENTO B
	ON A.ID_TIPO = B.ID_TIPO
	JOIN AHO_CUENTA_AHORRO C
	ON A.ID_CUENTA = C.ID_CUENTA
	WHERE B.DEBITO_CREDITO='D'
	GROUP BY A.ID_CUENTA)	
);
/*
posible parte 7
CREATE OR REPLACE VIEW importe_credito_cuentas AS
SELECT CA.id_cuenta id_cuenta, sum(NVL(MC.importe,0)) importe
FROM
	AHO_MOVIMIENTOS_CUENTA MC
	INNER JOIN AHO_TIPO_MOVIMIENTO TM ON MC.ID_TIPO = TM.ID_TIPO
	INNER JOIN AHO_CUENTA_AHORRO CA ON MC.id_cuenta = CA.id_cuenta
WHERE DEBITO_CREDITO = 'C'
GROUP BY CA.id_cuenta;

CREATE OR REPLACE VIEW importe_debito_cuentas AS
SELECT CA.id_cuenta id_cuenta, sum(NVL(MC.importe,0)+NVL(CA.SALDO_BLOQUEADO,0)) importe
FROM
	AHO_MOVIMIENTOS_CUENTA MC
	INNER JOIN AHO_TIPO_MOVIMIENTO TM ON MC.ID_TIPO = TM.ID_TIPO
	INNER JOIN AHO_CUENTA_AHORRO CA ON MC.id_cuenta = CA.id_cuenta
WHERE DEBITO_CREDITO = 'D'
GROUP BY CA.id_cuenta;

CREATE OR REPLACE VIEW importe_total AS
SELECT sum(imc.importe-idc.importe) importe, imc.id_cuenta
FROM
	importe_credito_cuentas imc
	JOIN importe_debito_cuentas idc ON idc.id_cuenta = imc.id_cuenta
GROUP BY imc.id_cuenta;

*/
column nombre format a20;
column apellido format a20;
column firma format a20;
column direccion format a30;
column email format A25;
