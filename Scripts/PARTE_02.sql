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


column nombre format a20;
column apellido format a20;
column firma format a20;
column direccion format a30;
column email format A25;
