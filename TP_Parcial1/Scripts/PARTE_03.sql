--3.1 (sin terminar)
--mas actualizado
create materialized view V_SOCIOS
build immediate
refresh start with (sysdate) next (trunc(sysdate)+1) + 22/24
as select S.ID_SOCIO Id_socio, S.CEDULA Cedula, S.NOMBRE||' '||S.APELLIDO as "Nombre y Apellido", sum(CA.SALDO_DISPONIBLE) Disponible, 
SUM(CASE CP.ESTADO WHEN 'A' THEN CC.MONTO_CUOTA ELSE 0 end) Deuda, 
SUM(CASE SC.TIPO_OBLIGACION WHEN 'A' THEN SC.Total_A_Abonar ELSE 0 end) Aporte
from SOC_SOCIO S join AHO_CUENTA_AHORRO CA
ON S.ID_SOCIO = CA.ID_SOCIO
JOIN CRE_SOLICITUD_PRESTAMOS CSP ON
S.ID_SOCIO = CSP.SOCIO_DEUDOR
JOIN CRE_PRESTAMOS CP ON
CSP.ID_SOL_CRED = CP.ID_SOL_CRED
JOIN CRE_CUOTAS CC ON
CP.NRO_PRESTAMO = CC.NRO_PRESTAMO
JOIN SOC_OBLIGACIONES SC ON
SC.ID_SOCIO = S.ID_SOCIO
group by S.id_socio, S.cedula, S.NOMBRE||' '||S.APELLIDO;


----MONTO CUOTAS ---NO PAGADAS---?????
fecha vencimiento < sysdate?

disponible, deuda, aportes tiene sumatoria

--3.2 (borrador)
create materialized view V_PRESTAMOS
build immediate
SELECT S.NOMBRE||' '||S.APELLIDO as "Nombre y Apellido", AI.VALOR_FISCAL as "Valor Activos"
FROM SOC_SOCIO S
JOIN CRE_SOLICITUD_PRESTAMOS CSP
ON S.ID_SOCIO = CSP.SOCIO_DEUDOR
JOIN CRE_PRESTAMOS CP
ON CP.ID_SOL_CRED=CSP.ID_SOL_CRED
JOIN ALD_INMUEBLES AI
ON AI.ID_SOCIO = S.ID_SOCIO
WHERE CP.ESTADO='A';