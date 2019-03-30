--PARTE 4

--4.10

--debe crearse estando conectado como el usuario creado en la parte 1 BD2TP/BD2TP

create user javierheisecke identified by javierheisecke	
       DEFAULT TABLESPACE BASED2TP
       TEMPORARY TABLESPACE TEMP;
GRANT CONNECT TO javierheisecke WITH ADMIN OPTION;

--4.1

spool C:\oraclexe\app\oracle\oradata\granteo.sql

SELECT 'GRANT INSERT, UPDATE, DELETE ON '|| TABLE_NAME ||' TO javierheisecke'
FROM tabs
WHERE TABLE_NAME LIKE 'CRE%' OR TABLE_NAME LIKE 'SOC%';

SELECT 'GRANT SELECT TO '|| TABLE_NAME ||'javierheisecke'
FROM tabs;

spool off

--Resultado

SELECT 'GRANT INSERT, UPDATE, DELETE ON '|| TABLE_NAME ||' TO javierheisecke'
  2  FROM tabs
  3  WHERE TABLE_NAME LIKE 'CRE%' OR TABLE_NAME LIKE 'SOC%';

'GRANTINSERT,UPDATE,DELETEON'||TABLE_NAME||'TOJAVIERHEISECKE'                                                                                                                                                                                             
--------------------------------------------------------------------------------                                                                                                                                                                          
GRANT INSERT, UPDATE, DELETE ON SOC_DETALLE_OBLIGACIONES TO javierheisecke                                                                                                                                                                                
GRANT INSERT, UPDATE, DELETE ON SOC_OBLIGACIONES TO javierheisecke                                                                                                                                                                                        
GRANT INSERT, UPDATE, DELETE ON SOC_SOCIO TO javierheisecke                                                                                                                                                                                               
GRANT INSERT, UPDATE, DELETE ON CRE_CUOTAS TO javierheisecke                                                                                                                                                                                              
GRANT INSERT, UPDATE, DELETE ON CRE_MODALIDAD_PRESTAMO TO javierheisecke                                                                                                                                                                                  
GRANT INSERT, UPDATE, DELETE ON CRE_PRESTAMOS TO javierheisecke                                                                                                                                                                                           
GRANT INSERT, UPDATE, DELETE ON CRE_SOLICITUD_PRESTAMOS TO javierheisecke                                                                                                                                                                                 

7 rows selected.

SQL> 
SQL> SELECT 'GRANT SELECT TO '|| TABLE_NAME ||'javierheisecke'
  2  FROM tabs;

'GRANTSELECTTO'||TABLE_NAME||'JAVIERHEISECKE'                                                                                                                                                                                                             
------------------------------------------------------------                                                                                                                                                                                              
GRANT SELECT TO SOC_SOCIOjavierheisecke                                                                                                                                                                                                                   
GRANT SELECT TO AHO_TIPO_MOVIMIENTOjavierheisecke                                                                                                                                                                                                         
GRANT SELECT TO AHO_CUENTA_AHORROjavierheisecke                                                                                                                                                                                                           
GRANT SELECT TO AHO_MOVIMIENTOS_CUENTAjavierheisecke                                                                                                                                                                                                      
GRANT SELECT TO CRE_MODALIDAD_PRESTAMOjavierheisecke                                                                                                                                                                                                      
GRANT SELECT TO CRE_SOLICITUD_PRESTAMOSjavierheisecke                                                                                                                                                                                                     
GRANT SELECT TO CRE_PRESTAMOSjavierheisecke                                                                                                                                                                                                               
GRANT SELECT TO CRE_CUOTASjavierheisecke                                                                                                                                                                                                                  
GRANT SELECT TO GEN_PARAMETROSjavierheisecke                                                                                                                                                                                                              
GRANT SELECT TO ALD_INMUEBLESjavierheisecke                                                                                                                                                                                                               
GRANT SELECT TO ALD_RODADOSjavierheisecke                                                                                                                                                                                                                 
GRANT SELECT TO SOC_OBLIGACIONESjavierheisecke                                                                                                                                                                                                            
GRANT SELECT TO SOC_DETALLE_OBLIGACIONESjavierheisecke                                                                                                                                                                                                    
GRANT SELECT TO ALD_DECLARACION_JURADAjavierheisecke                                                                                                                                                                                                      
GRANT SELECT TO ALD_CONCEPTOSjavierheisecke                                                                                                                                                                                                               
GRANT SELECT TO ALD_DETALLE_DECLARACIONjavierheisecke                                                                                                                                                                                                     
GRANT SELECT TO PRUEBA1javierheisecke                                                                                                                                                                                                                     
GRANT SELECT TO V_SOCIOSjavierheisecke                                                                                                                                                                                                                    

18 rows selected.

SQL> spool off