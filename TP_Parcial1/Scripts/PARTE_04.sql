create user javierheisecke identified by javierheisecke	
       DEFAULT TABLESPACE TPBD2
       TEMPORARY TABLESPACE TEMP;
GRANT CONNECT TO javierheisecke WITH ADMIN OPTION;

spool C:\oraclexe\app\oracle\oradata\granteo.sql

SELECT 'GRANT INSERT, UPDATE, DELETE ON '|| TABLE_NAME ||' TO javierheisecke'
FROM tabs
WHERE TABLE_NAME LIKE 'CRE%';

SELECT 'GRANT SELECT TO '|| TABLE_NAME ||'javierheisecke'
FROM tabs;

spool off