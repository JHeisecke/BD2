--3.1 (sin terminar)
create materialized view V_SOCIOS
build immediate
refresh start with (sysdate) next (trunc(sysdate)+1) + 22/24
as select S.ID_SOCIO Id_socio, S.CEDULA Cedula, S.NOMBRE||' '||S.APELLIDO as "Nombre y Apellido",
CA.SALDO_DISPONIBLE Disponible, SUM(CASE (CP.ESTADO WHEN 'A' THEN CC.MONTO_CUOTA ELSE 0)) Deuda, SUM(CASE (SC.TIPO_OBLIGACION WHEN 'A' THEN SC.Total_A_Abonar ELSE 0)) Aporte
from SOC_SOCIO S join AHO_CUENTA_AHORRO CA
ON S.ID_SOCIO = CA.ID_SOCIO
JOIN CRE_SOLICITUD_PRESTAMOS CSP ON
S.ID_SOCIO = CSP.SOCIO_DEUDOR
JOIN CRE_PRESTAMOS CP ON
CSP.ID_SOL_CRED = CP.ID_SOL_CRED
JOIN CRE_CUOTAS CC ON
CPS.NRO_PRESTAMO = CC.NRO_PRESTAMO
JOIN SOC_OBLIGACIONES SC ON
SC.ID_SOCIO = S.ID_SOCIO;
--(que pasa si no tiene deudas o si su estado no es A? usar NVL(NULL, 0) en cc monto_cuota?)
--(preguntar que si no cumple aun asi debe insertarse)
--(no necesariamente dice que la cuota debe estar vencida, entonces esta demas?)
--(donde esta aporte?)


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