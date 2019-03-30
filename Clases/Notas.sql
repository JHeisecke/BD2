--
DECLARE
CONT NUMBER;
BEGIN 
CONT :=0;
LOOP
	CONT := CONT +1;
	DBMS_OUTPUT.PUT_LINE(CONT);
	EXIT WHEN CONT=12;
	END LOOP;
END;

--
DECLARE
CONT NUMBER;
BEGIN 
CONT :=0;
WHILE CONT <12 LOOP
	CONT := CONT +1;
	DBMS_OUTPUT.PUT_LINE(CONT);
	END LOOP;
END;

--
DECLARE
CONT NUMBER;
BEGIN 
CONT :=0;
FOR CONT IN 1..12 LOOP
	DBMS_OUTPUT.PUT_LINE(CONT);
	END LOOP;
END;


DECLARE
v_jefe b_empleados.cedula_jefe%type := 952160;
v_nnom b_empleados.nombre%type;
v_nnom b_empleados.apellido%type;
BEGIN
select nombre, apellido into v_nom, v_ape
from b_empleados where cdula_jefe = v_jefe;
dbms_output.put_line(v_nom||', '||v_ape);
exception
	when too_many_rows then
		dbms_output.put_line('muchas filas');
	when NO_data_found then
		dbms_output.put_line('no hay filas'):
END;

--Cree un bloque PL/SQL que dada una variable alfanumérica (cuyo valor deberá ingresarse por teclado). Deberá
--imprimir dicha variable tal como se la introdujo, y posteriormente intercambiada. Ejemplo: Si intruduce
--‘123456’ deberá mostrar en pantalla ‘654321’ :
DECLARE
	num varchar2(30) := &a;
	CONT NUMBER;
	new_num varchar2(30);
BEGIN
	CONT :=1;
	new_num:='';
	FOR i IN REVERSE CONT..LENGTH( num ) LOOP
		concat(new_num,'',SUBSTRING(num,-i,1))
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(new_num);
END;










